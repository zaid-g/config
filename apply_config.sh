# %% -------- [make dirs] ----------:
echo "--- dirs ---"

mkdir -p ~/doc/junk
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/junk/
mkdir -p ~/trash/
mkdir -p ~/empty/
mkdir -p ~/pic/

# %% -------- [nvim base] ----------:
echo "--- nvim base ---"

mkdir -p ~/.config/nvim
touch -a ~/.config/nvim/init.lua
grep -qF 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))' ~/.config/nvim/init.lua || echo "$(
    cat ~/.config/nvim/init.lua
    printf '%s\n' 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))'
)" >~/.config/nvim/init.lua
grep -qF 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/nvim/nvim.lua"))' ~/.config/nvim/init.lua || echo "$(
    cat ~/.config/nvim/init.lua
    printf '%s\n' 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/nvim/nvim.lua"))'
)" >~/.config/nvim/init.lua

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

grep -qF 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))' "$LAZYVIM_TARGET/lua/config/keymaps.lua" || echo "$(
    printf '%s\n' 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))'
    cat "$LAZYVIM_TARGET/lua/config/keymaps.lua"
)" >"$LAZYVIM_TARGET/lua/config/keymaps.lua"

# %% -------- [zsh] ----------:
echo "--- zsh ---"

touch -a ~/.zshrc
grep -qF '. ~/doc/config/config/zsh/zshrc' ~/.zshrc || echo "$(
    printf '. ~/doc/config/config/zsh/zshrc\n'
    cat ~/.zshrc
)" >~/.zshrc

# %% -------- [tmux] ----------:
echo "--- tmux ---"

touch -a ~/.tmux.conf
grep -qF 'source-file ~/doc/config/config/tmux/tmux.conf' ~/.tmux.conf || echo "$(
    printf 'source-file ~/doc/config/config/tmux/tmux.conf\n'
    cat ~/.tmux.conf
)" >~/.tmux.conf

# %% -------- [python] ----------:
echo "--- python ---"

mkdir -p ~/.ipython/profile_default
cp ~/doc/config/config/python/pycodestyle ~/.config/
cp ~/doc/config/config/python/ipython_config.py ~/.ipython/profile_default/

# %% -------- [sway] ----------:
echo "--- sway ---"

mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
touch -a ~/.config/sway/config
grep -qF 'include ~/doc/config/config/sway/config' ~/.config/sway/config || echo "$(
    printf 'include ~/doc/config/config/sway/config\n'
    cat ~/.config/sway/config
)" >~/.config/sway/config
chmod +x ~/doc/config/config/sway/*.sh

# %% -------- [alacritty] ----------:
echo "--- alacritty ---"

mkdir -p ~/.config/alacritty
touch -a ~/.config/alacritty/alacritty.toml
grep -qF '[general]' ~/.config/alacritty/alacritty.toml || echo "$(
    cat ~/.config/alacritty/alacritty.toml
    printf '%s\n' '[general]'
)" >~/.config/alacritty/alacritty.toml
grep -qF 'import = ["~/doc/config/config/alacritty/alacritty.toml"]' ~/.config/alacritty/alacritty.toml || echo "$(
    cat ~/.config/alacritty/alacritty.toml
    printf '%s\n' 'import = ["~/doc/config/config/alacritty/alacritty.toml"]'
)" >~/.config/alacritty/alacritty.toml

# %% -------- [kitty] ----------:
echo "--- kitty ---"

mkdir -p ~/.config/kitty
touch -a ~/.config/kitty/kitty.conf
grep -qF 'include ~/doc/config/config/kitty/kitty.conf' ~/.config/kitty/kitty.conf || echo "$(
    cat ~/.config/kitty/kitty.conf
    printf '%s\n' 'include ~/doc/config/config/kitty/kitty.conf'
)" >~/.config/kitty/kitty.conf

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

# %% -------- [amazonq] ----------:
echo "--- amazonq ---"

mkdir -p ~/.aws/amazonq/cli-agents
cp ~/doc/config/config/aws/amazonq/cli-agents/* ~/.aws/amazonq/cli-agents/

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

echo "For treestyletabs config, load extension settings, preferences tab, expand Development, then import All Configs from file."

# %% -------- [kiro] ----------:
echo "--- kiro ---"

kiro-cli settings chat.disableWrap true

# %% -------- [done] ----------:
echo "--- done ---"
