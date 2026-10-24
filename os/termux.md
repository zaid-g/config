# Termux (Android) + proot-distro Debian

Termux/proot-specific quirks and their fixes. Most are kept out of the universal
config because they only apply here; where a fix *is* universal, this is the record of
why, so it does not get "tidied" back later.

Layout of the stack:

```
Termux (Android app)          TERM=xterm-256color  COLORTERM=truecolor  LANG=C.UTF-8
  └─ tmux (outer)             TERM=tmux-256color
       └─ proot-distro debian LANG unset   <-- dropped here
            └─ tmux (nested, -L nested_<ts>)
```

---

## Locale: UTF-8 must be set by hand inside proot

**Symptom.** Box-drawing characters, spinners and emoji mis-wrap, smear, or leave
stale fragments on screen in any TUI (claude code, nvim, tmux's own status line).
Text is not garbled in the file, only on screen.

**Cause.** Termux sets `LANG=C.UTF-8`, but `proot-distro login` does not propagate it,
so the Debian side starts in the `POSIX` locale. UTF-8 bytes are still emitted
correctly; what breaks is `wcwidth()`, which counts each *byte* of a multibyte glyph
as its own column. Alignment and wrapping are computed from those wrong widths.

Reproduce it — the same 5-character string under `%-10s`:

```sh
LC_ALL=POSIX   printf '[%-10s]END\n' '─────'   # [─────]END        counted as 15 columns, no padding
LC_ALL=C.UTF-8 printf '[%-10s]END\n' '─────'   # [─────     ]END   counted as 5, padded correctly
```

**Fix.** In machine-local `~/.zshrc` (not the synced config):

```sh
export LANG=C.UTF-8
```

`C.UTF-8` rather than `en_US.UTF-8` because the `locales` package is not installed in
this rootfs — `locale -a` offers only `C`, `C.utf8`, `POSIX`. `C.utf8` is built into
glibc and always present, so nothing needs generating. If you ever do want
`en_US.UTF-8`: `apt install locales && dpkg-reconfigure locales`.

**Verify.**

```sh
locale | grep LC_CTYPE                    # expect LC_CTYPE="C.UTF-8"
printf '[%-10s]END\n' '─────'             # expect the padded form
```

Note a running process cannot pick this up — it inherits its locale at exec. Restart
any long-lived TUI after changing it.

---

## Why `COLOR_TEXT_IF_COLORED_BACKGROUND` is 16 and not 0

Termux's terminal implements `bold` by substituting the *bright* variant of ANSI
colours 0-7. `window-status-current-style` is the only style carrying `bold`, so its
`fg=colour0` (black) was drawn as `colour8` (light grey) - the active window in the
status bar read light where other machines read black. tmux was emitting the style
correctly; terminals that skip the substitution show black. Same config, different
renderer.

The substitution only applies to the eight ANSI slots, so `zsh/zshrc` uses `colour16` -
the 256-colour cube's black, `#000000`, identical to `colour0` - which keeps bold weight
*and* black text. That fix is in the universal config, not here, because it depends on
how the palette is defined rather than on anything Termux-specific.

Caveat: colour schemes (Solarized, Dracula, Gruvbox) remap slots 0-15 but leave the cube
16-231 alone, so on a terminal themed that way the text is pure black instead of the
theme's near-black. Below 256 colours `colour16` does not exist at all.

The same promotion applies to any bold + colour 0-7, so expect it again if bold is added
to another style.

---

## Re-sourcing zshrc (`RS`) took 8 seconds

**Symptom.** A fresh shell started in ~0.25s, but `RS` (`source ~/.zshrc`) took ~8s
every time. The same config on a 2019 laptop re-sources in under 50ms.

**Cause.** Two things together:

1. *An ordering bug in machine-local `~/.zshrc`.* It sourced `zsh/zshrc` (which runs
   `compinit`) and only *then* ran `eval "$(brew shellenv zsh)"`, which does
   `fpath[1,0]=.../linuxbrew/share/zsh/site-functions`. Nothing stopped the duplicates,
   so every `RS` prepended the brew dir again (it was in `fpath` 8 times; `INFOPATH`
   and `PATH` grew the same way). `compinit` checks `~/.zcompdump` against the current
   `fpath` contents. A changed `fpath` meant a stale dump, so it threw the cache away
   and rescanned all ~1000 completion files (`compdef` called ~42k times).
2. *proot makes that rescan expensive.* proot intercepts every syscall via `ptrace`,
   so stat/open/fork-heavy work runs 10-100x slower than native, however fast the
   CPU is. A full rescan costs ~100ms natively and ~8s here, so the bug only shows on
   this machine.

**Fix.** In machine-local `~/.zshrc` (not the synced config):

```sh
# keep path arrays duplicate-free so re-sourcing (RS) doesn't keep growing them
typeset -U path fpath

# brew must set fpath BEFORE compinit (in zshrc below), and only once
[[ -z "$HOMEBREW_PREFIX" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

path=("$HOME/.local/bin" $path)

. ~/doc/config/config/zsh/zshrc
```

Gotcha: `export PATH="$HOME/.local/bin:$PATH"` **skips** the `typeset -U` dedupe, so
`.local/bin` still piled up on each `RS`. Assigning the tied array (`path=(...)`) is
deduped. Use the array form for anything prepended in a re-sourceable file.

The first shell after the change rebuilds `.zcompdump` once (~5s). After that a fresh
shell takes ~0.24s and `RS` ~0.1s.

**Verify.**

```sh
print -l $fpath | sort | uniq -d                  # expect no output (no duplicates)
time (source ~/.zshrc)                            # expect well under a second
```

**Profiling, if it regresses.** Trace with timestamps and total the time per function:

```sh
zsh -ic 'PS4="+%D{%s.%6.} %N:%i> "; exec 2>/tmp/trace.log; setopt xtrace; source ~/.zshrc'
awk '/^\+[0-9]/{t=substr($1,2); split($2,a,":"); if(p!=""){s[f]+=t-p} p=t; f=a[1]}
     END{for(k in s) printf "%.3f %s\n", s[k], k}' /tmp/trace.log | sort -rn | head
```

xtrace inflates the absolute numbers, but the ranking holds. If `compinit`/`compdef`
come out on top, check `fpath` first.

**General lesson for this machine.** Slowness here is almost always syscall count, not
CPU. Expect it from anything that touches many files or spawns many processes (git in
large repos, `brew`, `npm`, completion scans). Look for caches being invalidated before
blaming the hardware.

---

## `brew install` fails with `Permission denied - /usr/bin/env`

**Symptom.** Every bottle fails at the *Extracting* step:

```
Warning: Landlock ABI 10 or later is required to deny all network access; found ABI 6. ...
Permission denied - /usr/bin/env
Error: Failure while executing; `/usr/bin/env HOME=... sandbox_operation.rb extract` exited with 127.
```

**Cause.** Newer Homebrew runs bottle extraction (and builds/tests) inside a **Landlock**
sandbox on Linux. Landlock is enforced by the real Android kernel, against *real* paths.
proot only fakes paths: `/usr/bin/env` is actually somewhere under Termux's
`.../proot-distro/installed-rootfs/debian/`, which is outside what the sandbox allows, so
the kernel refuses to run it. Nothing is wrong with permissions inside Debian. (The
error, and the fix working, are confirmed. The real-path-versus-fake-path mechanism is
the most likely explanation but was not traced at kernel level.)

**Why brew does this.** Not aimed at Termux. The sandbox defends against malicious or
compromised packages (supply-chain attacks): installing means running code from the
internet, and the sandbox limits what an install step can touch (home folder, SSH keys,
network). macOS Homebrew has sandboxed builds for years; Linux caught up via Landlock.
proot is a ptrace hack, not real Linux, and doesn't emulate newer kernel features like
Landlock. Homebrew supports normal Linux installs; Debian under proot inside an Android
app is far outside that and goes untested. They did leave an off switch.

**Fix.** In machine-local `~/.zshrc`:

```sh
export HOMEBREW_NO_SANDBOX_LINUX=1
```

Homebrew marks this variable deprecated (it wants "a Landlock-enabled Linux kernel"), so
a future brew may drop it. If that happens, fall back to `apt install ripgrep fd-find`
(Debian names the binary `fdfind`). To push back, an issue on
[Homebrew/brew](https://github.com/Homebrew/brew/issues) explaining that Landlock breaks
under proot might keep the switch alive. Expect an "unsupported setup" reply.

---

## Termux's Android binaries leak onto PATH

**Symptom.** A tool works from plain Termux but fails inside Debian with Android linker
errors. Example from nvim-treesitter (`Installed 0/24 languages`):

```
WARNING: linker: library ".../tree-sitter-vim/parser.so" needed or dlopened by
"/data/data/com.termux/files/usr/bin/tree-sitter" is not accessible for the namespace ...
Error opening dynamic library ... -- dlopen failed
```

**Cause.** proot-distro writes `/etc/profile.d/termux-profile.sh`, which *appends*
`/data/data/com.termux/files/usr/bin` (Termux's own ~700 Android-built programs) to PATH,
so `termux-*` tools can be run from Debian. Because it's last, Debian/brew versions win.
But anything Debian lacks quietly falls through to the Android copy. Here Debian had no
`tree-sitter`, so nvim-treesitter used Termux's: Debian's gcc built a Linux `parser.so`,
and the Android binary couldn't load it. Android only allows loading libraries from
approved system dirs, and the file is linked against glibc anyway. `unzip` (used by Mason)
was falling back the same way.

**Fix.** In machine-local `~/.zshrc` (not `/etc/profile.d`, which proot-distro may
regenerate), drop the dir but keep just the `termux-*` tools through a symlink dir:

```zsh
path=(${path:#/data/data/com.termux/files/usr/bin} "$HOME/.local/termux-bin")
```

```sh
mkdir -p ~/.local/termux-bin
ln -sf /data/data/com.termux/files/usr/bin/termux-* ~/.local/termux-bin/
```

Re-run that `ln` after installing new termux packages on the Termux side, e.g.
`pkg install termux-api` for `termux-clipboard-set`. Keeping `termux-*` on PATH matters:
`apply_config.sh` detects Termux via `command -v termux-setup-storage`, and
`tmux/get_tmux_pane_identifier.sh` copies to the Android clipboard via
`termux-clipboard-set`. Aliases would not work, because scripts don't see them.

Then install Debian-side versions of whatever was falling back (`sudo` needs a password
here, so brew is the no-root route):

```sh
brew install tree-sitter-cli unzip
```

A missing tool now fails with a plain `command not found` instead of a linker error.
Confirmed 2026-10-10: after this, just restarting nvim let LazyVim retry and install the
parsers on its own (was 0/24). No `:TSUpdate` needed.

**Verify.**

```sh
print -l $path | grep com.termux          # expect no output
command -v tree-sitter unzip              # expect /home/linuxbrew/.linuxbrew/bin/...
command -v termux-setup-storage           # expect ~/.local/termux-bin/...
```

---

## Nerd Font icons missing in LazyVim (boxes / blanks)

**Symptom.** LazyVim's dashboard, file tree, status line and completion menu show boxes,
`?` or nothing where icons should be.

**Cause.** Those icons are **Nerd Font** glyphs: private-use codepoints patched into
fonts like JetBrains Mono. Termux renders text with exactly one file,
`~/.termux/font.ttf` in *Termux's* home (`/data/data/com.termux/files/home/.termux/`),
and falls back to its built-in font when it's absent. The built-in font has no Nerd glyphs.
Termux ignores system fonts, so nothing inside Debian affects this.

**Fix.** Drop a Nerd Font TTF into that one path and reload. It can be done from inside
Debian, because Termux's home is reachable here:

```sh
mkdir -p ~/tmp/nerdfont && cd ~/tmp/nerdfont
curl -fsSLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar -xJf JetBrainsMono.tar.xz
cp JetBrainsMonoNerdFontMono-Regular.ttf /data/data/com.termux/files/home/.termux/font.ttf
termux-reload-settings      # via ~/.local/termux-bin; or fully close + reopen Termux
```

Use the **`NerdFontMono`** variant. Its icons are exactly one cell wide, so nothing
misaligns in a terminal. The plain `NerdFont` variant has wider icons that can overlap the
next character. To switch fonts later, repeat with another archive from the
[nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

Why not brew/apt: Termux never reads installed fonts, so a package would only be a
roundabout download that still needs this copy. Debian's `fonts-jetbrains-mono` is the
plain font without icons anyway. The Termux:Styling app (F-Droid) writes the same
`font.ttf` via a GUI picker.

**Verify.**

```sh
printf '    \n'   # expect 5 icons, not boxes
```

Confirmed working 2026-10-10.

---

## Not a Termux issue, but it bit this machine

`~/.local/state/nvim/shada/main.shada` was corrupted on 2026-09-07 by two nvim
instances writing it in the same second — one in `~/doc/brain`, one in a backup copy
under `~/doc/scratch/`. The result was a content-level *overlay* (1020 bytes =
`max(609, 1020)`, not the sum), which means the final step was not an atomic
`rename()`. Plain `rename()` would have left one intact file, last writer wins; proot
emulates path syscalls and has `link2symlink` active (`PROOT_L2S_DIR`), so two
concurrent renames into one target interleaved by content.

The error does not self-heal: nvim refuses to rename over a file that fails its ShaDa
sanity check (`E136`), so every exit orphaned another `main.shada.tmp.*` instead.

```sh
rm ~/.local/state/nvim/shada/main.shada*   # costs marks + :oldfiles, nothing else
```

## git delta

`sudo apt install git-delta`
