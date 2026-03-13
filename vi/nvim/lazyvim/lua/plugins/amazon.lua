-- requires nvim 0.11
-- based on https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/extras/lang/java.lua#L4
return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"jdtls",
				-- add other LSP servers here, they will automatically get installed by mason-lspconfig
				-- "lua_ls",
				-- "pyright",
			},
			automatic_enable = {
				-- We will enable jdtls ourselves in attach_jdtls()
				exclude = { "jdtls" },
			},
		},
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		config = function()
			local attach_jdtls = function()
				local default_config = require("lspconfig.configs.jdtls").default_config
				local cmd = default_config.cmd

				-- lombok support
				local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
				if vim.uv.fs_stat(lombok_jar) then
					table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
				end

				-- setup bemol workspaces
				local root_dir = require("jdtls.setup").find_root({ "packageInfo" }, "Config")
				if root_dir then
					local ws_file = io.open(root_dir .. "/.bemol/ws_root_folders")
					if ws_file then
						for line in ws_file:lines() do
							vim.lsp.buf.add_workspace_folder(line)
						end
						ws_file:close()
					end
				end

				-- keymaps
				vim.keymap.set("n", "<leader>co", require("jdtls").organize_imports, { desc = "Organize Imports" })

				require("jdtls").start_or_attach({
					cmd = cmd,
					root_dir = root_dir,
				})
			end

			vim.api.nvim_create_autocmd("Filetype", {
				pattern = "java",
				callback = attach_jdtls,
			})

			attach_jdtls()
		end,
	},
}
