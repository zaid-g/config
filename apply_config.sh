# %% -------- [make dirs] ----------:

echo "***      Creating Dirs         ***"
mkdir -p ~/doc
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/junk/
mkdir -p ~/pic/
mkdir -p ~/.config/nvim
mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
mkdir -p ~/.config/alacritty
mkdir -p ~/.ipython/profile_default

# %% -------- [nvim] ----------:

# touch -a ~/.config/nvim/init.lua
# grep -qF 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/basic.lua"))' ~/.config/nvim/init.lua || echo "$(
#     cat ~/.config/nvim/init.lua
#     printf '%s\n' 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/basic.lua"))'
# )" >~/.config/nvim/init.lua
# grep -qF 'dofile(vim.fn.expand("~/doc/config/config/vi/nvim/advanced.lua"))' ~/.config/nvim/init.lua || echo "$(
#     cat ~/.config/nvim/init.lua
#     printf '%s\n' '--dofile(vim.fn.expand("~/doc/config/config/vi/nvim/advanced.lua"))'
# )" >~/.config/nvim/init.lua

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

# %% -------- [done] ----------:

echo "***      Done       ***"
