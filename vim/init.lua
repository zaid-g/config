-- Save undo history
vim.o.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Comment.nvim
require("Comment").setup{
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = '<leader>cc',
        ---Block-comment keymap
        block = '<leader>cb',
    }
}

-- Indent blankline
require("ibl").setup {
    indent = { char = "┊" },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false
            }
        }
    }
}

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, {desc = "[?] Find recently opened files"})
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, {desc = "[ ] Find existing buffers"})
vim.keymap.set(
    "n",
    "<leader>t/",
    function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false
            }
        )
    end,
    {desc = "[/] Fuzzily search in current buffer]"}
)

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, {desc = "[S]earch [F]iles"})
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, {desc = "[S]earch [H]elp"})
vim.keymap.set("n", "<leader>tsw", require("telescope.builtin").grep_string, {desc = "[S]earch current [W]ord"})
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, {desc = "[S]earch by [G]rep"})
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, {desc = "[S]earch [D]iagnostics"})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {"c", "cpp", "go", "lua", "python", "rust", "typescript", "vim"},
    highlight = {enable = true},
    indent = {enable = true, disable = {"python"}},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>"
        }
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer"
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer"
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer"
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer"
            }
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner"
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner"
            }
        }
    }
}


-- nvim-cmp and snippets (autocomplete)
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone"

local cmp = require "cmp"
local luasnip = require "luasnip"

cmp.setup({
    snippet = {
        expand = function(args)
        luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['\\<TAB>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources(
        {
            { name = "nvim_lsp" },
            { name = "amazonq" },
            { name = "luasnip"}
        }
    ),
    experimental = {
        ghost_text = true,
    }
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {noremap = true, silent = true}
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    vim.keymap.set("n", "<leader>td", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set(
        "n",
        "<leader>f",
        function()
            vim.lsp.buf.format {async = true}
        end,
        bufopts
    )
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150
}

-- pyright. check out OS install script. `npm i -g pyright`
require("lspconfig")["pyright"].setup {
    on_attach = on_attach,
    flags = lsp_flags
}

-- efm. check out OS install script. `brew install efm-langserver`
require("lspconfig")["efm"].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    init_options = {documentFormatting = true},
    filetypes = {"python", "lua"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {formatCommand = "lua-format -i", formatStdin = true}
            },
            python = {
                {formatCommand = "black --quiet -", formatStdin = true}
            }
        }
    }
}

-- jsonls. `npm i -g vscode-langservers-extracted`
require("lspconfig")["jsonls"].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    init_options = {documentFormatting = true},
    filetypes = {"json", "jsonc"},
    settings = {
        rootMarkers = {".git/"}
    }
}

-- ccls (for c/c++). `brew install ccls`
require("lspconfig")["ccls"].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    init_options = {
        documentFormatting = true,
        compilationDatabaseDirectory = "build",
        index = {
            threads = 0
        },
        clang = {
            excludeArgs = {"-frounding-math"}
        }
    },
    settings = {
        rootMarkers = {".git/"}
    }
}

-- copilot (need to install node `brew install node`)
require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "\\<TAB>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})


-- amazon q codewhisperer
require('AmazonQNVim').setup({
    ssoStartUrl = "https://amzn.awsapps.com/start",
    lsp_server_cmd = { 'node', '/home/zghar/.local/share/nvim/site/pack/downloaded/start/AmazonQNVim/language-server/build/aws-lsp-codewhisperer-token-binary.js', '--stdio' },
})
