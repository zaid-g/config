


-- %% -------- [settings] ----------:

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = true
vim.g.autoformat = false
vim.opt.relativenumber = false
vim.g.snacks_animate = false
vim.opt.autoread = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 200
vim.opt.conceallevel = 0

-- %% -------- [leader stuff] ----------:

-- frees up m to use for my own mappings (don't override leader since lazyvim sets it)
vim.keymap.set({ "n", "x" }, "mm", "m")

-- frees up \ to use for my own mappings in insert mode
vim.keymap.set("i", "\\\\", "\\")

-- %% -------- [movements] ----------:

-- additional scroll movements, moving text
-- we steal J, K here
vim.keymap.set("n", "<C-d>", ":set scroll=0<CR><C-d>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", ":set scroll=0<CR><C-u>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "J", "1<C-D>", { silent = true })
vim.keymap.set({ "n", "x" }, "K", "1<C-U>", { silent = true })
vim.keymap.set({ "n", "x" }, "mj", "J$")
vim.keymap.set({ "n", "x" }, "mk", "K")
-- lazyvim restore functionality for j, k
vim.keymap.set({'n', 'x'}, 'j', 'j', { desc = "Down" })
vim.keymap.set({'n', 'x'}, 'k', 'k', { desc = "Up" })

-- %% -------- [simple copy paste clipboard] ----------:

-- copy to system clipboard
vim.keymap.set({ "n", "x" }, "Y", '"+y', { silent = true })
-- multiple paste
vim.keymap.set("x", "p", [["_dP]], { noremap = true, silent = true })
-- dont override clipboard using c (black hole register)
vim.keymap.set({ "n", "x" }, "c", [["_c]], { noremap = true, silent = true })
-- don't override clipboard using x (black hole register)
vim.keymap.set({ "n", "x" }, "x", [["_x]], { noremap = true, silent = true })

-- %% -------- [emojis] ----------:

-- special characters
vim.keymap.set("i", "\\c", "<c-v>u2705")
vim.keymap.set("i", "\\C", "<c-v>u274c")

-- %% -------- [word count] ----------:

-- word count, and because of conflict with tmux prefix
vim.keymap.set("v", "m<c-n>", "g<C-g>2gs")
vim.keymap.set("n", "m<c-n>", "g<C-g>")

-- %% -------- [highlight, color, search, jump, find, and replace] ----------:

-- n always searches down and N always up, whether the search was started with / or ?
-- (zv opens a fold if the match is inside one, as LazyVim's own mapping does)
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true })

function JumpToPattern(count, pattern, flags, center)
	for _ = 1, count do
		vim.fn.search(pattern, flags)
	end
	if center then
		vim.cmd("normal! zz")
	end
end

-- search and highlight without jump
function SearchNoJump(pattern)
	vim.fn.setreg("/", pattern)
	vim.opt.hlsearch = true
	vim.cmd("redraw")
end

vim.keymap.set(
	"n",
	"m/",
	[[<cmd>lua vim.ui.input({prompt = 'Search case insensitive: '}, function(input) if input then SearchNoJump('\\c' .. input) end end)<CR>]]
)

-- copy matches to system clipboard
local function copy_matches_to_register(reg)
	local pattern = vim.fn.getreg("/") -- Get current search pattern
	if pattern == "" then
		print("No search pattern found.")
		return
	end
	local matches = {}
	for lnum = 1, vim.fn.line("$") do
		local line = vim.fn.getline(lnum)
		local start = 0
		while true do
			local result = vim.fn.matchstrpos(line, pattern, start)
			local match_text = result[1]
			local match_start = result[2]
			local match_end = result[3]
			if match_start == -1 then
				break
			end
			table.insert(matches, match_text)
			start = match_end
		end
	end
	if #matches == 0 then
		print("No matches found.")
		return
	end
	local joined = table.concat(matches, "\n")
	vim.fn.setreg(reg, joined)
	print("Copied " .. #matches .. " matches to register " .. reg)
end
vim.keymap.set("n", "my", function()
	copy_matches_to_register('"') -- Default register
end, { silent = true, desc = "Copy matches to default register" })
vim.keymap.set("n", "mY", function()
	copy_matches_to_register("+") -- System clipboard
end, { silent = true, desc = "Copy matches to clipboard" })

-- cursor/visual highlight and search
vim.keymap.set("n", "ml", function()
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

vim.keymap.set("v", "ml", function()
	SetSearchVisualSelection()
	vim.opt.hlsearch = true
end, { silent = true })

-- find and replace mappings
vim.keymap.set("n", "mcs", ":%s/<C-R>=@/<CR>//g<Left><Left>")
vim.keymap.set("v", "mcs", ":s/<C-R>=@/<CR>//g<Left><Left>")
vim.keymap.set("n", "mct", ":%s//g<Left><Left>")
vim.keymap.set("v", "mct", ":s//g<Left><Left>")
vim.keymap.set(
	"n",
	"mbdcs",
	":bufdo %s/<C-R>=@/<CR>//g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>"
)
vim.keymap.set(
	"n",
	"mbdct",
	":bufdo %s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>"
)
-- replace each match append index of match i
vim.keymap.set("n", "mci", ":let @a=1 | %s/search/\\='replace'.(@a+setreg('a',@a+1))/g")

-- %% -------- [buffers windows and loading files] ----------:

-- auto read files
vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI", "BufEnter"}, {
  command = "silent! checktime"
})

-- recursively load files of type
vim.keymap.set("n", "mar", ":args **/*.")

-- bufdo e without loss of syntax highlighting and switching buffers
vim.keymap.set("n", "me", ":tabdo windo e<CR>")

-- split window vertically on new column
vim.keymap.set("n", "msb", ":botr vs<CR>:b ")

-- scratch window
vim.keymap.set("n", "msw", "<c-w>n:setlocal buftype=nofile<CR>:setlocal bufhidden=hide<CR>:setlocal noswapfile<CR>")

-- print full path of current buffer
vim.keymap.set("n", "mFP", ":echo expand('%:p')<CR>", { silent = true })

-- %% -------- [git] ----------:

-- git branch sessions
function MakeSessionGit()
	local git_branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
	vim.fn.mkdir(".vim", "p")
	vim.cmd("mksession! .vim/" .. git_branch .. ".vim")
	print("Session saved for branch: " .. git_branch)
end

vim.keymap.set("n", "mks", MakeSessionGit)

-- %% -------- [block abstraction] ----------:

-- add block title
vim.keymap.set("n", "mbl", function()
	local commentstr = vim.bo.commentstring:gsub("%%s", "") -- Remove %s placeholder
	if vim.bo.filetype == "markdown" then
		commentstr = "#"
	end
	local line = commentstr .. " %% -------- [" .. vim.fn.strftime("%a %Y_%m_%d-%H_%M_%S") .. ": ] ----------:"
	vim.cmd("normal! o")
	vim.cmd("normal! k")
	vim.api.nvim_put({ "", "", line, "" }, "l", true, true)
	vim.cmd("normal! kk")
	-- cursor on the closing bracket, so startinsert types just before it
	vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), line:find("]", 1, true) - 1 })
	vim.cmd("startinsert")
end, { desc = "Insert block comment" })

-- add header
vim.keymap.set("n", "mhe", function()
	local commentstr = vim.bo.commentstring:gsub("%%s", "")
	if vim.bo.filetype == "markdown" then commentstr = "#" end
	local line = commentstr .. " %% -- [] --:"
	vim.api.nvim_put({ line }, "l", true, true)
	vim.cmd("normal! k$BBe")
	vim.cmd("startinsert")
end, { desc = "Insert subheader comment" })

-- search in block title
vim.keymap.set("n", "mb/", "/%% -----.*.*<left><left>\\c")
vim.keymap.set("n", "mb?", "?%% -----.*.*<left><left>\\c")

-- jump
vim.keymap.set({ "n", "x" }, "<c-j>", function()
	BlockJumpDown(vim.v.count1)
end, { silent = true })
vim.keymap.set({ "n", "x" }, "<c-k>", function()
	BlockJumpUp(vim.v.count1)
end, { silent = true })
vim.keymap.set({ "n", "x" }, "mJ", "<c-j>")
vim.keymap.set({ "n", "x" }, "mK", "<c-k>")

function BlockJumpUp(count)
	JumpToPattern(count, [[\(\%^\)\|\(.*\] ----------:\n\)]], "b", true)
end

function BlockJumpDown(count)
	JumpToPattern(count, [[\(\%$\)\|\(.*\] ----------:\n\)]], "", true)
end

-- %% -------- [python] ----------:

-- ipdb trace above current line
vim.keymap.set("n", "mp", "Oimport ipdb; ipdb.set_trace()<ESC>:w<CR>")

-- timeit
vim.keymap.set(
	"x",
	"mvt",
	'<ESC>`<Oimport time; my_start_time = time.time()<ESC>`>oprint("my_end_time - my_start_time = ", time.time() - my_start_time)<ESC>'
)

-- %% -------- [plantuml] ----------:

-- plantuml on current buffer
vim.keymap.set("n", "mP", ":w<CR>:!plantuml %&<CR><CR>", { silent = true })
