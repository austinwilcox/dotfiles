local map = vim.api.nvim_set_keymap
local utils = require("austinwilcox.utils")

map("n", "<Space>", "", {})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local noremap_options = { noremap = true }

--NOTE: Sensible remaps, some from the Primeagen
map("v", "K", ":m '<-2<CR>gv=gv", noremap_options)
map("v", "J", ":m '>+1<CR>gv=gv", noremap_options)
map("i", "<C-j>", "<esc>:m .+1<CR>==", noremap_options)
map("i", "<C-k>", "<esc>:m .-2<CR>==", noremap_options)
map("n", "<leader>k", ":m .-2<CR>==", noremap_options)
map("n", "<leader>j", ":m .+1<CR>==", noremap_options)
map("n", "Y", "y$", noremap_options)
map("n", "n", "nzz", noremap_options)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--NOTE: Helix inspired mappings
map("n", "gl", "$", noremap_options)
map("n", "gh", "^", noremap_options)
map("n", "ge", "GG", noremap_options)
map("v", "gl", "$", noremap_options)
map("v", "gh", "^", noremap_options)
map("n", "mm", "%", noremap_options)
map("v", "mm", "%", noremap_options)

--NOTE: Emacs window hopping
map("n", "<leader>wh", ":wincmd h<CR>", noremap_options)
map("n", "<leader>wj", ":wincmd j<CR>", noremap_options)
map("n", "<leader>wk", ":wincmd k<CR>", noremap_options)
map("n", "<leader>wl", ":wincmd l<CR>", noremap_options)

--NOTE: Window sizing
map("n", "<leader>+", ":vertical resize +5<CR>", noremap_options)
map("n", "<leader>-", ":vertical resize -5<CR>", noremap_options)

--NOTE: Autocommands
vim.cmd([[
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal linebreak
]])
