return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        vim.keymap.set("n", "gft", ":diffget //2<CR>", {})
        vim.keymap.set("n", "gfn", ":diffget //3<CR>", {})
    end
}
