--

-- %% -------- [lsp keymaps completion autocomplete cmp auto comp] ----------:

-- easier reach expand/complete mode
vim.keymap.set("i", "<c-c>", "<c-x>")

-- word completion using tab and shift tab (instead of c-n c-p)
vim.keymap.set("i", "<TAB>", "<c-n>")
vim.keymap.set("i", "<S-TAB>", "<c-p>")

vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format file with LSP" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "Go to Definition" })

-- %% -------- [plugins lazy.nvim] ----------:

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- %% -------- [darcula color] ----------:
	{
		"briones-gabriel/darcula-solid.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme darcula-solid")
		end,
	},

	-- %% -------- [vim-slime] ----------:

	{
		"jpalardy/vim-slime",
		config = function()
			-- Global settings
			vim.g.slime_target = "tmux"
			vim.g.slime_python_ipython = 1
			vim.g.slime_default_config = { socket_name = "default", target_pane = ".0" }
			vim.g.slime_dont_ask_default = 1
			-- Keymaps
			vim.keymap.set("n", "<leader>sc", ":SlimeConfig<CR>")
			vim.keymap.set("x", "<leader>ss", "<Plug>SlimeRegionSend", { silent = true })
			vim.keymap.set("n", "<leader>ss", "0W<c-k>V<c-j>:SlimeSend<CR>gv<Esc>", { remap = true })
		end,
	},

	-- %% -------- [vim-eunuch] ----------:

	{
		"tpope/vim-eunuch",
		config = function()
			vim.keymap.set("n", "<leader>RN", ":Rename ", { silent = false })
		end,
	},

	-- %% -------- [winresizer windows resizer win resizer] ----------:

	{
		"simeji/winresizer",
		lazy = false, -- Load immediately
		init = function()
			vim.g.winresizer_start_key = "<leader>w"
		end,
	},

	-- %% -------- [Comment.nvim] ----------:

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				---LHS of operator-pending mappings in NORMAL and VISUAL mode
				opleader = {
					---Line-comment keymap
					line = "<leader>cc",
					---Block-comment keymap
					block = "<leader>cb",
				},
			})
		end,
	},

	-- %% -------- [indent blankline] ----------:

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
			})
		end,
	},

	-- %% -------- [telescope] ----------:

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
			vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>t/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer]" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>tsw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		end,
	},

	-- %% -------- [treesitter] ----------:

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the listed parsers MUST always be installed)
				ensure_installed = {
					"c",
					"cpp",
					"lua",
					"go",
					"vim",
					"python",
					"rust",
					"typescript",
					"java",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (or "all")
				ignore_install = { "javascript" },

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,

					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					disable = { "c", "rust" },
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	-- %% -------- [lspconfig] ----------:

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")

			-- Lua LSP
			lspconfig.lua_ls.setup({
				root_dir = lspconfig.util.root_pattern(".git", ".luarc.json", ".luarc.jsonc", "init.lua"),
				on_attach = function()
					print("Lua LSP attached!")
				end,
			})

			-- Java LSP
			lspconfig.jdtls.setup({
				cmd = { "jdtls" },
				root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
				on_attach = function()
					print("Java LSP attached!")
				end,
			})

			-- Python LSP (Pyright)
			lspconfig.pyright.setup({
				root_dir = lspconfig.util.root_pattern(
					".git",
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt"
				),
				on_attach = function()
					print("Python LSP attached!")
				end,
			})

			-- TypeScript/JavaScript LSP (typescript-language-server)
			lspconfig.ts_ls.setup({
				root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
				on_attach = function()
					print("TypeScript LSP attached!")
				end,
			})
		end,
	},

	-- %% -------- [mason.nvim] ----------:

	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	-- %% -------- [mason-lspconfig] ----------:

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "jdtls", "lua_ls", "ts_ls", "pyright" },
				automatic_installation = true,
			})
		end,
	},

	-- %% -------- [null-ls for linters formatters for stylua formatter lua black] ----------:

	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- Lua formatting with stylua
					null_ls.builtins.formatting.stylua.with({
						filetypes = { "lua" }, -- Only format Lua files
					}),

					-- Python formatting with black
					null_ls.builtins.formatting.black.with({
						filetypes = { "python" }, -- Only format Python files
						extra_args = { "--fast" }, -- Optional: speeds up formatting
					}),
				},
			})
		end,
	},
})
