return {
    "neovim/nvim-lspconfig",
    opts = function()
        local keys = require("lazyvim.plugins.lsp.keymaps").get()
        -- disable K keymap
        keys[#keys + 1] = { "K", false }
    end
}
