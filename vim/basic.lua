--

-- %% -------- [leader stuff] ----------:

-- frees up m to use for my own mappings
vim.keymap.set("n", "mm", "m")

-- mapleader
vim.g.mapleader = "m"

-- frees up \ to use for my own mappings in insert mode
vim.keymap.set("i", "\\\\", "\\")

-- %% -------- [movements] ----------:

-- additional scroll movements, moving text
vim.keymap.set({ "n", "x" }, "J", '@="j\\<lt>C-E>"<CR>', { silent = true })
vim.keymap.set({ "n", "x" }, "K", '@="k\\<lt>C-Y>"<CR>', { silent = true })
vim.keymap.set({ "n", "x" }, "<leader>j", "J$")
vim.keymap.set({ "n", "x" }, "<leader>k", "K")
vim.keymap.set({ "n", "x" }, "<leader>J", "<c-j>")
vim.keymap.set({ "n", "x" }, "<leader>K", "<c-k>")
vim.keymap.set({ "n", "x" }, "<c-j>", function()
    BlockJumpDown(vim.v.count1)
end, { silent = true })
vim.keymap.set({ "n", "x" }, "<c-k>", function()
    BlockJumpUp(vim.v.count1)
end, { silent = true })

-- robust jump/search pattern function
function JumpToPattern(count, pattern, flags, center)
    for _ = 1, count do
        vim.fn.search(pattern, flags)
    end
    if center then
        vim.cmd("normal! zz")
    end
end

function BlockJumpUp(count)
    JumpToPattern(count, [[\(\%^\)\|\(.*\] ----------:\n\)]], "b", true)
end

function BlockJumpDown(count)
    JumpToPattern(count, [[\(\%$\)\|\(.*\] ----------:\n\)]], "", true)
end

-- %% -------- [copy paste clipboard] ----------:

-- copy to system clipboard
vim.keymap.set({ "n", "x" }, "Y", '"+y', { silent = true })

-- allows multiple pasting of copied text
vim.keymap.set("x", "p", "pgvy")

-- do not overwrite register with s
vim.keymap.set("n", "s", '"_s')

-- delete to black hole register
vim.keymap.set("", "<leader>x", '"_x')

-- %% -------- [emojis] ----------:

-- special characters
vim.keymap.set("i", "\\c", "<c-v>u2705")
vim.keymap.set("i", "\\C", "<c-v>u274c")

-- %% -------- [word count] ----------:

-- word count, and because of conflict with tmux prefix
vim.keymap.set("v", "g<c-n>", "g<C-g>2gs")
vim.keymap.set("n", "g<c-n>", "g<C-g>")

-- %% -------- [highlight, color, search, find, and replace] ----------:

-- visual settings
vim.cmd("silent! colo koehler")
vim.opt.termguicolors = true
vim.o.cursorline = false
vim.opt.hlsearch = true
vim.cmd("hi MatchParen cterm=none ctermbg=darkgreen")
vim.opt.number = true
vim.cmd("syntax on")
vim.opt.laststatus = 2

-- clear highlight
vim.keymap.set("n", "<Space>", ":noh<CR>")

-- cursor/visual highlight and search
vim.keymap.set("n", "<leader>l", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.opt.hlsearch = true
    vim.cmd("normal! wb")
end, { silent = true })

function SetSearchVisualSelection()
    -- Store original clipboard content
    local clipboard_original_content = vim.fn.getreg('"')
    -- Yank the visual selection
    vim.cmd("normal! y")
    -- Get the yanked text
    local raw_search = vim.fn.getreg('"')
    -- Escape special characters and replace newlines
    local escaped_search = vim.fn.escape(raw_search, "\\/.*$^~[]")
    -- Replace newlines with '\n'
    local search_pattern = escaped_search:gsub("\n", "\\n")
    -- Set the search register
    vim.fn.setreg("/", search_pattern)
    -- Restore original clipboard content
    vim.fn.setreg('"', clipboard_original_content)
end

vim.keymap.set("v", "<leader>l", function()
    SetSearchVisualSelection()
    vim.opt.hlsearch = true
end, { silent = true })

-- find and replace mappings
vim.keymap.set("n", "<leader>cs", ":%s/<C-R>=@/<CR>//g<Left><Left>")
vim.keymap.set("v", "<leader>cs", ":s/<C-R>=@/<CR>//g<Left><Left>")
vim.keymap.set("n", "<leader>ct", ":%s//g<Left><Left>")
vim.keymap.set("v", "<leader>ct", ":s//g<Left><Left>")
vim.keymap.set(
    "n",
    "<leader>bdcs",
    ":bufdo %s/<C-R>=@/<CR>//g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>"
)
vim.keymap.set(
    "n",
    "<leader>bdct",
    ":bufdo %s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>"
)
vim.keymap.set("n", "<leader>ci", ":let @a=1 | %s/search/\\='replace'.(@a+setreg('a',@a+1))/g")

-- %% -------- [buffers windows and loading files] ----------:

-- recursively load files of type
vim.keymap.set("n", "<leader>ar", ":args **/*.")

-- bufdo e without loss of syntax highlighting and switching buffers
vim.keymap.set("n", "<leader>e", ":tabdo windo e<CR>")

-- split window vertically on new column
vim.keymap.set("n", "<leader>sb", ":botr vs<CR>:b ")

-- scratch window
vim.keymap.set(
    "n",
    "<leader>sw",
    "<c-w>n:setlocal buftype=nofile<CR>:setlocal bufhidden=hide<CR>:setlocal noswapfile<CR>"
)

-- %% -------- [git] ----------:

-- git branch sessions
function MakeSessionGit()
    local git_branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
    vim.cmd("silent! !mkdir -p .vim/" .. git_branch .. ".vim")
    vim.cmd("silent! !rm -rf .vim/" .. git_branch .. ".vim")
    vim.cmd("silent! mksession! .vim/" .. git_branch .. ".vim")
end

vim.keymap.set("n", "<leader>ks", MakeSessionGit)

-- %% -------- [block abstraction] ----------:

-- block abstraction and execution
vim.keymap.set("n", "<leader>bl", "o<CR><CR><CR><ESC>2ki%% -------- [] ----------:<ESC>gccWWWa")
vim.keymap.set("n", "<leader>y", "w<c-k>V<c-j>ygv<Esc>")
vim.keymap.set("n", "<leader>Y", 'w<c-k>V<c-j>"+ygv<Esc>')
vim.keymap.set("n", "<leader>/", "/%% -----.*.*<left><left>\\c")
vim.keymap.set("n", "<leader>?", "?%% -----.*.*<left><left>\\c")

-- %% -------- [python] ----------:

-- ipdb trace above current line
vim.keymap.set("n", "<leader>p", "Oimport ipdb; ipdb.set_trace()<ESC>:w<CR>")

-- timeit
vim.keymap.set(
    "x",
    "<leader>vt",
    '<ESC>`<Oimport time; my_start_time = time.time()<ESC>`>oprint("my_end_time - my_start_time = ", time.time() - my_start_time)<ESC>'
)

-- %% -------- [plantuml] ----------:

-- plantuml on current buffer
vim.keymap.set("n", "<leader>P", ":w<CR>:!plantuml %&<CR><CR>", { silent = true })

-- %% -------- [settings] ----------:

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- other settings
vim.opt.autoread = true
vim.cmd("filetype plugin indent on")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.opt.completeopt:remove("preview")

-- Save undo history
vim.o.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- %% -------- [lsp keymaps completion autocomplete cmp auto comp] ----------:

-- easier reach expand/complete mode
vim.keymap.set("i", "<c-c>", "<c-x>")

-- word completion using tab and shift tab (instead of c-n c-p)
vim.keymap.set("i", "<TAB>", "<c-n>")
vim.keymap.set("i", "<S-TAB>", "<c-p>")


vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format file with LSP" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true })

