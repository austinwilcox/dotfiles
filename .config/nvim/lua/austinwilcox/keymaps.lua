local utils = require("austinwilcox.utils")
local map = vim.keymap.set

-- Move lines
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
map("i", "<C-j>", "<esc>:m .+1<CR>==", { noremap = true })
map("i", "<C-k>", "<esc>:m .-2<CR>==", { noremap = true })
map("n", "<leader>k", ":m .-2<CR>==", { noremap = true })
map("n", "<leader>j", ":m .+1<CR>==", { noremap = true })

-- Yank to end of line
map("n", "Y", "y$", { noremap = true })

-- Center on search
map("n", "n", "nzz", { noremap = true })

-- Helix-inspired motions
map({ "n", "v" }, "gl", "$", { noremap = true })
map({ "n", "v" }, "gh", "^", { noremap = true })
map("n", "ge", "GG", { noremap = true })
map({ "n", "v" }, "mm", "%", { noremap = true })

-- Visual search for selected text
map("v", "//", function()
  vim.cmd('normal! "vy')
  local word = vim.fn.escape(vim.fn.getreg('"'), [[\/]])
  vim.fn.setreg("/", "\\V" .. word)
  vim.cmd("normal! n")
end, { noremap = true, silent = true })

-- Copy file path to clipboard
if utils.IsWindows() then
  map("n", "<leader>cf", ':let @* = expand("%")<CR>', { noremap = true })
else
  map("n", "<leader>cf", ':let @+ = expand("%")<CR>', { noremap = true })
end

-- Window navigation
map("n", "<leader>wh", "<C-w>h", { noremap = true })
map("n", "<leader>wj", "<C-w>j", { noremap = true })
map("n", "<leader>wk", "<C-w>k", { noremap = true })
map("n", "<leader>wl", "<C-w>l", { noremap = true })

-- Window sizing
map("n", "<leader>+", ":vertical resize +5<CR>", { noremap = true })
map("n", "<leader>-", ":vertical resize -5<CR>", { noremap = true })

-- Disable Alt-p (autopairs toggle)
map("n", "<M-p>", "<Nop>", { noremap = true })

-- Zettelkasten date stamp
map("n", "<leader>z", function()
  local current_date = os.date("%Y%m%d%H%M%S")
  local r = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0, r - 1, r, false)
  vim.api.nvim_buf_set_lines(0, r - 1, r, -1, { current_date .. lines[1] })
end, { noremap = true })
map("n", "<leader>zn", ":ObsidianNew ", { noremap = true })
map("n", "<leader>zt", ":ObsidianTemplate<cr>", { noremap = true })
map("n", "<leader>zd", ":ObsidianToday<cr>", { noremap = true })

-- Merge conflict helper
vim.api.nvim_create_user_command("Meld", "Gvdiffsplit!", {})
