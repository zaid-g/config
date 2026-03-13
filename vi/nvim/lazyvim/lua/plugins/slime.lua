return {
  "jpalardy/vim-slime",
  config = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_python_ipython = 1
    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = ".0"
    }
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_no_mappings = 1
    
    vim.keymap.set("n", "msc", ":<C-u>SlimeConfig<CR>")
    vim.keymap.set("x", "mss", "<Plug>SlimeRegionSend", { silent = true })
    vim.keymap.set("n", "mss", "0W<c-k>V<c-j>:SlimeSend<CR>gv<Esc>", { silent = true, remap = true })
  end,
}
