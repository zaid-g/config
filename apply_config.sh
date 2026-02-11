# %% -------- [make dirs] ----------:

echo "***      Creating Dirs         ***"
mkdir -p ~/doc
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/junk/
mkdir -p ~/trash/
mkdir -p ~/empty/
mkdir -p ~/pic/
mkdir -p ~/.config/nvim
mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
mkdir -p ~/.config/alacritty
mkdir -p ~/.ipython/profile_default

# %% -------- [nvim base] ----------:

touch -a ~/.config/nvim/init.lua
grep -qF 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))' ~/.config/nvim/init.lua || echo "$(
    cat ~/.config/nvim/init.lua
    printf '%s\n' 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/core.lua"))'
)" >~/.config/nvim/init.lua

#  %% -------- [lazyvim] ----------:

bash ~/doc/config/config/vi/lazyvim/apply_config.sh
cp ~/doc/config/config/vi/nvim/core.lua ~/.config/lazyvim/lua/config/keymaps.lua

# %% -------- [zsh] ----------:

touch -a ~/.zshrc
grep -qF '. ~/doc/config/config/zsh/zshrc' ~/.zshrc || echo "$(
    printf '. ~/doc/config/config/zsh/zshrc\n'
    cat ~/.zshrc
)" >~/.zshrc

# %% -------- [tmux] ----------:

touch -a ~/.tmux.conf
grep -qF 'source-file ~/doc/config/config/tmux/tmux.conf' ~/.tmux.conf || echo "$(
    printf 'source-file ~/doc/config/config/tmux/tmux.conf\n'
    cat ~/.tmux.conf
)" >~/.tmux.conf

# %% -------- [python] ----------:

# pycodestyle
cp ~/doc/config/config/python/pycodestyle ~/.config/
# ipython
cp ~/doc/config/config/python/ipython_config.py ~/.ipython/profile_default/

# %% -------- [sway] ----------:

cp ~/doc/config/config/sway/* ~/.config/sway/
chmod +x ~/.config/sway/clamshell.sh
chmod +x ~/.config/sway/status.sh

# %% -------- [alacritty] ----------:

touch -a ~/.config/alacritty/alacritty.toml
grep -qF '[general]' ~/.config/alacritty/alacritty.toml || echo "$(
    cat ~/.config/alacritty/alacritty.toml
    printf '%s\n' '[general]'
)" >~/.config/alacritty/alacritty.toml
grep -qF 'import = ["~/doc/config/config/alacritty/alacritty.toml"]' ~/.config/alacritty/alacritty.toml || echo "$(
    cat ~/.config/alacritty/alacritty.toml
    printf '%s\n' 'import = ["~/doc/config/config/alacritty/alacritty.toml"]'
)" >~/.config/alacritty/alacritty.toml

# %% -------- [git] ----------:

bash ~/doc/config/config/git/setup.sh

# %% -------- [amazonq] ----------:

mkdir -p ~/.aws/amazonq/cli-agents
cp ~/doc/config/config/aws/amazonq/cli-agents/* ~/.aws/amazonq/cli-agents/

# %% -------- [firefox] ----------:
if [[ "$OSTYPE" == "darwin"* ]]; then
    PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PROFILE_DIR="$HOME/.mozilla/firefox"
fi

# Try to find default-release first, then fall back to default
DEFAULT_PROFILE=$(find "$PROFILE_DIR" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
if [[ -z "$DEFAULT_PROFILE" ]]; then
    DEFAULT_PROFILE=$(find "$PROFILE_DIR" -maxdepth 1 -name "*.default" -type d 2>/dev/null | head -1)
fi

if [[ -n "$DEFAULT_PROFILE" ]]; then
    cp ~/doc/config/config/firefox/user.js "$DEFAULT_PROFILE/user.js"
    mkdir -p "$DEFAULT_PROFILE/chrome"
    cp ~/doc/config/config/firefox/userChrome.css "$DEFAULT_PROFILE/chrome/userChrome.css"
    echo "✅ Firefox config applied to: $(basename "$DEFAULT_PROFILE")"
else
    echo "❌ No Firefox profile found"
fi

# %% -------- [done] ----------:

echo "***      Done       ***"
