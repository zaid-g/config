

# %% -------- [general] ----------:
echo "--- general ---"

PREPEND_LINE_IF_NOT_EXISTS() {
    local file="$1" line="$2"
    mkdir -p "$(dirname "$file")"
    touch -a "$file"
    grep -qFx "$line" "$file" && return
    echo "$(printf '%s\n' "$line"; cat "$file")" >"$file"
}

mkdir -p ~/doc/junk
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/junk/
mkdir -p ~/trash/
mkdir -p ~/empty/
mkdir -p ~/pic/

# %% -------- [wsl windows subsystem for linux] ----------:
echo "--- wsl ---"

IS_WSL=false
if [[ -n "$WSL_DISTRO_NAME" ]] && command -v wslpath >/dev/null 2>&1; then
    WIN_USERPROFILE="$(
        win_userprofile_raw=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')
        [[ -n "$win_userprofile_raw" ]] || exit 1
        wslpath "$win_userprofile_raw"
    )"
    [[ -n "$WIN_USERPROFILE" ]] && IS_WSL=true
fi

# Downloads folder
if [[ "$IS_WSL" == "true" ]]; then
    WIN_DOWNLOADS_DIR="$WIN_USERPROFILE/Downloads"
    mkdir -p "$WIN_DOWNLOADS_DIR"
    rm -rf ~/Downloads
    ln -s "$WIN_DOWNLOADS_DIR" ~/Downloads
    echo "✅ ~/Downloads symlinked to Windows Downloads: $WIN_DOWNLOADS_DIR"
else
    mkdir -p ~/Downloads
fi

# %% -------- [nvim base] ----------:
echo "--- nvim base ---"

PREPEND_LINE_IF_NOT_EXISTS ~/.config/nvim/init.lua 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/nvim/nvim.lua"))'
PREPEND_LINE_IF_NOT_EXISTS ~/.config/nvim/init.lua 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))'

#  %% -------- [lazyvim] ----------:
echo "--- lazyvim ---"

LAZYVIM_SRC=~/doc/config/config/vi/nvim/lazyvim
LAZYVIM_TARGET=~/.config/lazyvim

if [[ ! -d "$LAZYVIM_TARGET" ]]; then
    git clone https://github.com/LazyVim/starter "$LAZYVIM_TARGET"
fi

find "$LAZYVIM_SRC" -type f -name "*.lua" | while read -r file; do
    rel_path="${file#$LAZYVIM_SRC/}"
    target_file="$LAZYVIM_TARGET/$rel_path"
    mkdir -p "$(dirname "$target_file")"
    cp "$file" "$target_file"
done

PREPEND_LINE_IF_NOT_EXISTS "$LAZYVIM_TARGET/lua/config/keymaps.lua" 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))'

# %% -------- [zsh] ----------:
echo "--- zsh ---"

PREPEND_LINE_IF_NOT_EXISTS ~/.zshrc '. ~/doc/config/config/zsh/zshrc'

# %% -------- [tmux] ----------:
echo "--- tmux ---"

PREPEND_LINE_IF_NOT_EXISTS ~/.tmux.conf 'source-file ~/doc/config/config/tmux/tmux.conf'

# %% -------- [python] ----------:
echo "--- python ---"

mkdir -p ~/.ipython/profile_default
cp ~/doc/config/config/python/pycodestyle ~/.config/
cp ~/doc/config/config/python/ipython_config.py ~/.ipython/profile_default/

# %% -------- [sway] ----------:
echo "--- sway ---"

mkdir -p ~/.config/waybar
PREPEND_LINE_IF_NOT_EXISTS ~/.config/sway/config 'include ~/doc/config/config/sway/config'
chmod +x ~/doc/config/config/sway/*.sh

# %% -------- [alacritty] ----------:
echo "--- alacritty ---"

PREPEND_LINE_IF_NOT_EXISTS ~/.config/alacritty/alacritty.toml 'import = ["~/doc/config/config/alacritty/alacritty.toml"]'
PREPEND_LINE_IF_NOT_EXISTS ~/.config/alacritty/alacritty.toml '[general]'

# also apply to Windows-native Alacritty when running under WSL
if [[ "$IS_WSL" == "true" ]]; then
    REPO_ALACRITTY_PATH="$HOME/doc/config/config/alacritty/alacritty.toml"
    WIN_STYLE_PATH="${REPO_ALACRITTY_PATH//\//\\}"
    UNC_PATH="\\\\wsl.localhost\\$WSL_DISTRO_NAME$WIN_STYLE_PATH"
    WIN_ALACRITTY_FILE="$WIN_USERPROFILE/AppData/Roaming/alacritty/alacritty.toml"
    PREPEND_LINE_IF_NOT_EXISTS "$WIN_ALACRITTY_FILE" "import = ['$UNC_PATH']"
    PREPEND_LINE_IF_NOT_EXISTS "$WIN_ALACRITTY_FILE" '[general]'
    echo "✅ Alacritty config applied to (Windows): $WIN_ALACRITTY_FILE"
fi

# %% -------- [kitty] ----------:
echo "--- kitty ---"

PREPEND_LINE_IF_NOT_EXISTS ~/.config/kitty/kitty.conf 'include ~/doc/config/config/kitty/kitty.conf'

# %% -------- [git] ----------:
echo "--- git ---"

git config --global delta.minus-style "syntax #990000"
git config --global delta.plus-style "syntax #004400"
git config --global delta.line-numbers true
git config --global delta.line-numbers-left-format "{nm:>4}┊"
git config --global delta.line-numbers-right-format "{np:>4}│"
git config --global delta.word-diff-regex "\\w+|[^\\w\\s]+"
git config --global delta.minus-emph-style "syntax #ff0000"
git config --global delta.plus-emph-style "syntax #008800"
git config --global delta.whitespace-error-style "reverse purple"
git config --global core.excludesfile ~/.gitignore_global
echo ".local/" >> ~/.gitignore_global
git config --global init.defaultBranch main

# %% -------- [firefox] ----------:
echo "--- firefox ---"

if [[ "$OSTYPE" == "darwin"* ]]; then
    PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PROFILE_DIR="$HOME/.mozilla/firefox"
    [[ ! -d "$PROFILE_DIR" ]] && PROFILE_DIR="$HOME/.config/mozilla/firefox"
fi

DEFAULT_PROFILE=$(find "$PROFILE_DIR" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
if [[ -z "$DEFAULT_PROFILE" ]]; then
    DEFAULT_PROFILE=$(find "$PROFILE_DIR" -maxdepth 1 -name "*.default" -type d 2>/dev/null | head -1)
fi

if [[ -n "$DEFAULT_PROFILE" ]]; then
    cp ~/doc/config/config/firefox/user.js "$DEFAULT_PROFILE/user.js"
    mkdir -p "$DEFAULT_PROFILE/chrome"
    cp ~/doc/config/config/firefox/userChrome.css "$DEFAULT_PROFILE/chrome/userChrome.css"
    echo "✅ Firefox config applied to: $DEFAULT_PROFILE"
else
    echo "❌ No Firefox profile found"
fi

# also apply to Windows-native Firefox when running under WSL
if [[ "$IS_WSL" == "true" ]]; then
    WIN_PROFILE_DIR="$WIN_USERPROFILE/AppData/Roaming/Mozilla/Firefox/Profiles"
    WIN_DEFAULT_PROFILE=$(find "$WIN_PROFILE_DIR" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
    if [[ -z "$WIN_DEFAULT_PROFILE" ]]; then
        WIN_DEFAULT_PROFILE=$(find "$WIN_PROFILE_DIR" -maxdepth 1 -name "*.default" -type d 2>/dev/null | head -1)
    fi
    if [[ -n "$WIN_DEFAULT_PROFILE" ]]; then
        cp ~/doc/config/config/firefox/user.js "$WIN_DEFAULT_PROFILE/user.js"
        mkdir -p "$WIN_DEFAULT_PROFILE/chrome"
        cp ~/doc/config/config/firefox/userChrome.css "$WIN_DEFAULT_PROFILE/chrome/userChrome.css"
        echo "✅ Firefox config applied to (Windows): $WIN_DEFAULT_PROFILE"
    else
        echo "❌ No Windows Firefox profile found"
    fi
fi

echo "For treestyletabs config, load extension settings, preferences tab, expand Development, then import All Configs from file."

# %% -------- [kiro] ----------:
echo "--- kiro ---"

kiro-cli settings chat.disableWrap true

# %% -------- [done] ----------:
echo "--- done ---"
