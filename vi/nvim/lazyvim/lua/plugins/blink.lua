return {
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        local ft = vim.bo.filetype
        return ft ~= "text" and ft ~= "markdown"
      end,
    },
  },
}
