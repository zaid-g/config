# macOS

macOS-specific quirks and their fixes. Most live outside the repo (in
`~/Library`), so this is the record of what was changed and why.

---

## Ctrl+/ plays the alert sound in Alacritty

**Symptom.** Every Ctrl+/ in Alacritty plays the macOS alert sound, even though the
key still reaches the terminal (it types `/`). zsh and tmux settings can't silence
it: the terminal bell isn't involved.

**Cause.** macOS plays the alert sound when an app passes it a key combination its
text system doesn't recognise, and Ctrl+/ isn't one. Alacritty passes every key
through that system. Reported in
[alacritty/alacritty#3014](https://github.com/alacritty/alacritty/issues/3014)
(open since 2019); iTerm2 doesn't have the problem.

**Fix.** Declare Ctrl+/ as a valid combination that does nothing. Create
`~/Library/KeyBindings/DefaultKeyBinding.dict`:

```
{
    "^/" = "noop:";
}
```

Check the syntax with `plutil -lint ~/Library/KeyBindings/DefaultKeyBinding.dict`.

Apps read this file when they start, so quit Alacritty (Cmd+Q) and reopen it. No
reboot needed. tmux sessions survive; reattach with `tmux attach`.

The file applies to every Cocoa app, so the same fix works for other apps that beep
on a shortcut (VS Code, Chrome, Obsidian): add one `noop:` line per key combination.
Modifiers: `^` Ctrl, `~` Option, `@` Cmd, `$` Shift.
