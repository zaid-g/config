-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'md', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', 'mq', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'mh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  vim.keymap.set('n', 'mtd', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'mrn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'mca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'mf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- pyright. check out OS install script
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags
}


-- efm. check out OS install script
require('lspconfig')['efm'].setup {
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
require('lspconfig')['jsonls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    init_options = {documentFormatting = true},
    filetypes = {"json", "jsonc"},
    settings = {
        rootMarkers = {".git/"}
    }
}

-- ccls (for c/c++). `brew install ccls`
require('lspconfig')['ccls'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    init_options = {
        documentFormatting = true,
        compilationDatabaseDirectory = "build";
        index = {
          threads = 0;
        };
        clang = {
          excludeArgs = { "-frounding-math"} ;
        };
    },
    settings = {
        rootMarkers = {".git/"}
    }
}
