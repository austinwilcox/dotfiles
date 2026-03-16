return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    vim.keymap.set("n", "<leader>gfn", ":diffget //3<CR>", {})
    vim.keymap.set("n", "<leader>gft", ":diffget //2<CR>", {})
  end,
}
