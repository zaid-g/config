vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI", "BufEnter"}, {
  command = "silent! checktime *"
})
