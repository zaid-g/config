--

-- %% -------- [leader stuff] ----------:

-- frees up m to use for my own mappings
vim.keymap.set("n", "mm", "m")

-- frees up \ to use for my own mappings in insert mode
vim.keymap.set("i", "\\\\", "\\")

-- %% -------- [movements] ----------:

-- additional scroll movements, moving text
vim.keymap.set({ "n", "x" }, "J", '@="j\\<lt>C-E>"<CR>', { silent = true })
vim.keymap.set({ "n", "x" }, "K", '@="k\\<lt>C-Y>"<CR>', { silent = true })
vim.keymap.set({ "n", "x" }, "mj", "J$")
vim.keymap.set({ "n", "x" }, "mk", "K")
vim.keymap.set({ "n", "x" }, "mJ", "<c-j>")
vim.keymap.set({ "n", "x" }, "mK", "<c-k>")

-- %% -------- [simple copy paste clipboard] ----------:

-- copy to system clipboard
vim.keymap.set({ "n", "x" }, "Y", '"+y', { silent = true })

-- allows multiple pasting of copied text
vim.keymap.set("x", "p", "pgvy")

-- do not overwrite register with s
vim.keymap.set({ "n", "x" }, "s", '"_s')

-- delete to black hole register
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- %% -------- [emojis] ----------:

-- special characters
vim.keymap.set("i", "\\c", "<c-v>u2705")
vim.keymap.set("i", "\\C", "<c-v>u274c")

-- %% -------- [word count] ----------:

-- word count, and because of conflict with tmux prefix
vim.keymap.set("v", "g<c-n>", "g<C-g>2gs")
vim.keymap.set("n", "g<c-n>", "g<C-g>")

-- %% -------- [highlight, color, search, jump, find, and replace] ----------:

-- visual settings
vim.cmd("silent! colo koehler")
vim.opt.termguicolors = true
vim.o.cursorline = false
vim.opt.hlsearch = true
vim.cmd("hi MatchParen cterm=none ctermbg=darkgreen")
vim.opt.number = true
vim.cmd("syntax on")
vim.opt.laststatus = 2

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

function CopyAllSearchMatchesToRegister()
	local matches = {}
	local pattern = vim.fn.getreg("/") -- current search pattern

	if pattern == "" then
		print("No active search pattern.")
		return
	end

	-- Save current position to restore later
	local cur_pos = vim.api.nvim_win_get_cursor(0)

	-- Start from top of the buffer
	vim.api.nvim_win_set_cursor(0, { 1, 0 })

	while true do
		-- search() returns 0 if no match is found
		local found = vim.fn.search(pattern, "W") -- 'W' means don't wrap
		if found == 0 then
			break
		end

		-- Get the full matched text using matchstr + line()
		local line = vim.fn.getline(".")
		local col = vim.fn.col(".")
		local match = vim.fn.matchstr(line:sub(col), pattern)

		if match ~= "" then
			table.insert(matches, match)
		end

		-- Move one char forward to avoid infinite loop on repeated matches
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end

	-- Restore original position
	vim.api.nvim_win_set_cursor(0, cur_pos)

	-- Set to unnamed register
	vim.fn.setreg('"', table.concat(matches, "\n"))
	print("Copied " .. #matches .. ' matches to register "')
end

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

-- clear highlight
vim.keymap.set("n", "<Space>", ":noh<CR>")

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

-- recursively load files of type
vim.keymap.set("n", "mar", ":args **/*.")

-- bufdo e without loss of syntax highlighting and switching buffers
vim.keymap.set("n", "me", ":tabdo windo e<CR>")

-- split window vertically on new column
vim.keymap.set("n", "msb", ":botr vs<CR>:b ")

-- scratch window
vim.keymap.set(
	"n",
	"msw",
	"<c-w>n:setlocal buftype=nofile<CR>:setlocal bufhidden=hide<CR>:setlocal noswapfile<CR>"
)

-- switch to last window
vim.keymap.set('n', '<ESC><ESC>', 'g<TAB>')

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

-- block abstraction and execution
vim.keymap.set("n", "mbl", function()
	local commentstr = vim.bo.commentstring:gsub("%%s", "") -- Remove %s placeholder
	if vim.bo.filetype == "markdown" then
		commentstr = "#"
	end
	local line = commentstr .. " %% -------- [] ----------:"
    vim.cmd("normal! o")
    vim.cmd("normal! k")
	vim.api.nvim_put({ "", "", line, "" }, "l", true, true)
	vim.cmd("normal! kk$BBe")
	vim.cmd("startinsert")
end, { desc = "Insert block comment" })
vim.keymap.set("n", "mb/", "/%% -----.*.*<left><left>\\c")
vim.keymap.set("n", "mb?", "?%% -----.*.*<left><left>\\c")

-- jump
vim.keymap.set({ "n", "x" }, "<c-j>", function()
	BlockJumpDown(vim.v.count1)
end, { silent = true })
vim.keymap.set({ "n", "x" }, "<c-k>", function()
	BlockJumpUp(vim.v.count1)
end, { silent = true })

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

-- %% -------- [settings] ----------:

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

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
