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

--NOTE: Lua output date for zettels
map('n', '<leader>z', ':lua print_current_date()<cr>', noremap_options)
function print_current_date()
  local current_date = os.date("%Y%m%d%H%M%S")
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0, r-1, r, false)
  local line = unpack(lines)
  vim.api.nvim_buf_set_lines(0, r-1, r, -1, {current_date .. line})
end
map("n", "<leader>zn", ":ObsidianNew ", noremap_options)
map("n", "<leader>zt", ":ObsidianTemplate<cr>", noremap_options)
map("n", "<leader>zd", ":ObsidianToday<cr>", noremap_options)

--NOTE: Helix inspired mappings
map("n", "gl", "$", noremap_options)
map("n", "gh", "^", noremap_options)
map("v", "gl", "$", noremap_options)
map("v", "gh", "^", noremap_options)
map("n", "ge", "GG", noremap_options)
map("n", "mm", "%", noremap_options)
map("v", "mm", "%", noremap_options)

vim.keymap.set("v", "//", function()
	vim.cmd('normal! "vy')
	local word = vim.fn.escape(vim.fn.getreg('"'), [[\/]])
	vim.fn.setreg("/", "\\V" .. word)
	vim.cmd("normal! n")
end, { noremap = true, silent = true })

--NOTE: Copy the file name and path to clipboard
if utils.IsWindows() then
	map("n", "<leader>cf", ':let @* = expand("%")<CR>', noremap_options)
else
	map("n", "<leader>cf", ':let @+ = expand("%")<CR>', noremap_options)
end

--NOTE: Fugitive Keybinding
map("n", "<leader>gfn", ":diffget //3<CR>", {})
map("n", "<leader>gft", ":diffget //2<CR>", {})
map("n", "<leader>gs", ":G<CR>", {})

--NOTE: Git Worktrees Bindings
map("n", "<leader>gw", ':lua require("telescope").extensions.git_worktree.git_worktrees()<cr>', noremap_options)
map("n", "<leader>gc", ':lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>', noremap_options)

--NOTE: I use the Meld command here because that's my favorite gui application for
--handling merge conflicts
vim.cmd([[command! -nargs=0 Meld Gvdiffsplit!]])

--NOTE: Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", noremap_options)
map("n", "<leader>?", "<cmd>Telescope live_grep<cr>", noremap_options)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", noremap_options)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", noremap_options)

--NOTE: Emacs window hopping
map("n", "<leader>wh", ":wincmd h<CR>", noremap_options)
map("n", "<leader>wj", ":wincmd j<CR>", noremap_options)
map("n", "<leader>wk", ":wincmd k<CR>", noremap_options)
map("n", "<leader>wl", ":wincmd l<CR>", noremap_options)

--NOTE: Window sizing
map("n", "<leader>+", ":vertical resize +5<CR>", noremap_options)
map("n", "<leader>-", ":vertical resize -5<CR>", noremap_options)

--NOTE: Hex 2 RGBA Plugin
map("n", "<leader>cs", ':lua require("hex2rgba").hex2rgba()<cr>', noremap_options)

--NOTE: Disable Escape p for Auto Pairs. Escape p trigger auto pairs to toggle
map("n", "<M-p>", "<Nop>", noremap_options)

--TODO: Find the code that was handling this, I had a simple plugin that would toggle a menu
--Keybindings popup
map("n", "<leader>test", ':lua require("nvimkeybindsnippet").toggle_keybinding_menu()<CR>', noremap_options)

--NOTE: GoTo Preview Keybindings
-- DO NOT USE THE LEADER KEY!!!
-- I have <leader>gp mapped to vim.diagnostic.goto_prev
map("n", "gpd", ':lua require("goto-preview").goto_preview_definition()<CR>', noremap_options)
map("n", "gpt", ':lua require("goto-preview").goto_preview_type_definition()<CR>', noremap_options)
map("n", "gpi", ':lua require("goto-preview").goto_preview_implementation()<CR>', noremap_options)
map("n", "gP", ':lua require("goto-preview").close_all_win()<CR>', noremap_options)
--NOTE: Only set if you have telescope installed
map("n", "gpr", ':lua require("goto-preview").goto_preview_references()<CR>', noremap_options)

--NOTE: Autocommands
vim.cmd([[
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal linebreak
]])
