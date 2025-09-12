-- JAVA (and other LSP) Setup

-- helper function for checking if a table contains a value
local function contains(table, value)
  for _, table_value in ipairs(table) do
    if table_value == value then
      return true
    end
  end

  return false
end

-- Bemol populates LSP
local function bemol()
  local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
  local ws_folders_lsp = {}
  if bemol_dir then
    local file = io.open(bemol_dir .. "/ws_root_folders", "r")
    if file then
      for line in file:lines() do
        table.insert(ws_folders_lsp, line)
      end
      file:close()
    end

    for _, line in ipairs(ws_folders_lsp) do
      if not contains(vim.lsp.buf.list_workspace_folders(), line) then
        vim.lsp.buf.add_workspace_folder(line)
      end
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        url = "ssh://git.amazon.com/pkg/VimBrazilConfig",
        branch = "mainline",
        ft = "brazil-config",
      },
    },
    opts = {
      setup = {
        -- Barium - Amazon internal LSP for detecting Config files
        barium = function(_, _)
          local lspconfig = require("lspconfig")
          local configs = require("lspconfig.configs")
          vim.filetype.add({
            ["Config"] = function()
              vim.b.brazil_package_Config = 1
              return "brazil-config"
            end,
          })
          configs.barium = {
            default_config = {
              cmd = { "barium" },
              filetypes = { "brazil-config" },
              root_dir = function(fname)
                vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
              end,
              settings = {},
            },
          }
          lspconfig.barium.setup({})
          return true
        end,
      },
    },
  },

  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    opts = function()
      local cmd = { vim.fn.exepath("jdtls") }
      if LazyVim.has("mason.nvim") then
        local mason_registry = require("mason-registry")
        local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
      end
      return {
        -- How to find the root dir for a given filename. The default comes from
        -- lspconfig which provides a function specifically for java projects.
        root_dir = function(_)
          require("jdtls.setup").find_root({ ".bemol", "packageInfo" })
        end,

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return os.getenv("HOME") .. ".local/share/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. ".local/share/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = cmd,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,

        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = "auto", config_overrides = {} },
        -- Can set this to false to disable main class scan, which is a performance killer for large project
        dap_main = {},
        test = true,
        settings = {
          java = {
            completion = {
              enabled = true,
              importOrder = { "java", "javax", "org", "amazon", "com", "" },
            },
            eclipse = {
              downloadSources = true,
            },
            format = {
              settings = {
                url = "~/.config/nvim/format/java-codestyle-intellij.xml",
              },
            },
            maven = {
              downloadSources = true,
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
            references = {
              includeDecompiledSources = true,
            },
            telemetry = {
              enabled = false,
            },
          },
        },
        on_attach = bemol,
      }
    end,
  },
}
