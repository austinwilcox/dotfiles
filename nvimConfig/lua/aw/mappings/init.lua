local vim = vim
local api = vim.api
local M = {}
function M.map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.map("n", "<M-p>", "<nop>")
M.map("n", "<leader>k", ":m .-2<CR>==")
M.map("n", "<leader>j", ":m .+1<CR>==")
M.map("n", "Y", "y$")
M.map("n", "<leader>wh", ":wincmd h<CR>")
M.map("n", "<leader>wj", ":wincmd j<CR>")
M.map("n", "<leader>wk", ":wincmd k<CR>")
M.map("n", "<leader>wl", ":wincmd l<CR>")
M.map("n", "<leader>+", ":vertical resize +5<CR>", { silent = true })
M.map("n", "<leader>-", ":vertical resize -5<CR>", { silent = true })
M.map("n", "<leader>of", ":OmniSharpCodeFormat<CR>")
M.map("n", "<leader>opi", ":OmniSharpPreviewImplementation<CR>")
M.map("n", "<leader>or", ":OmniSharpRestartServer<CR>")
M.map("n", "<leader>ogt", ":OmniSharpGotoDefinition<CR>")
M.map("n", "<leader>oi", ":OmniSharpFindImplementations<CR>")
M.map("n", "<leader>gn", ":diffget //3<CR>")
M.map("n", "<leader>gt", ":diffget //2<CR>")
M.map("n", "<leader>gs", ":G<CR>")
M.map("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>")
M.map("n", "<leader>hs", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
M.map("n", "<leader>hn", ":lua require('harpoon.ui').nav_file(1)<CR>")
M.map("n", "<leader>he", ":lua require('harpoon.ui').nav_file(2)<CR>")
M.map("n", "<leader>hi", ":lua require('harpoon.ui').nav_file(3)<CR>")
M.map("n", "<leader>ho", ":lua require('harpoon.ui').nav_file(4)<CR>")
M.map("n", "<leader>n", ":NERDTreeFocus<CR>")
M.map("n", "<C-n>", ":NERDTree<CR>")
M.map("n", "<C-t>", ":NERDTreeToggle<CR>")
M.map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
M.map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
M.map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
M.map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
--Experimental
M.map("n", "<leader>cs", ":lua require('aw.colorswap').hex2rgb<CR>")
M.map("n", ",html", ":-1read $HOME/.dotfiles/skeletons/skeleton.html<CR>3jwf>a")
M.map("n", ",react", ":-1read $HOME/.dotfiles/skeletons/skeleton.jsx<CR>2j3wce")
M.map("n", ",vue", ":-1read $HOME/.dotfiles/skeletons/skeleton.vue<CR>ja")
M.map("n", ",csdto", ":-1read $HOME/.dotfiles/skeletons/csdto.cs<CR>4jwce")
M.map("n", "<leader>tt", ":vnew term://bash<CR>")

--TODO
--:tnoremap <Esc> <C-\><C-n>
M.map("t", "<Esc>", "<C-\\><C-n>")

M.map("v", "K", ":m '<-2<CR>gv=gv'")
M.map("v", "J", ":m '>+1<CR>gv=gv'")

M.map("i", "<C-j>", "<esc>:m .+1<CR>==")
M.map("i", "<C-k>", "<esc>:m .-2<CR>==")

M.map("c", "w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")
return M
