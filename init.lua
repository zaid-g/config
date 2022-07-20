vim.lsp.set_log_level("debug")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'mh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'mgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'mrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'mca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'md', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'mq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', 'mf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end


local nvim_lsp = require('lspconfig')


-- pyright. check out OS install script
nvim_lsp.pyright.setup{
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
}


-- efm. check out OS install script
nvim_lsp.efm.setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
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
nvim_lsp.jsonls.setup{
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = {documentFormatting = true},
    filetypes = {"json", "jsonc"},
    settings = {
        rootMarkers = {".git/"}
    }
}

-- ccls (for c/c++). `brew install ccls`
nvim_lsp.ccls.setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
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
