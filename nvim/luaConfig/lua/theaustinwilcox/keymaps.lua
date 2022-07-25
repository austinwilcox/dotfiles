local map = vim.api.nvim_set_keymap

map('n', '<Space>', '', {})
vim.g.mapleader = " "

local noremap_options = { noremap = true }
-- Sensible remaps
map('v', 'K', ':m \'<-2<CR>gv=gv', noremap_options)
map('v', 'J', ':m \'>+1<CR>gv=gv', noremap_options)
map('i', '<C-j>', '<esc>:m .+1<CR>==', noremap_options)
map('i', '<C-k>', '<esc>:m .-2<CR>==', noremap_options)
map('n', '<leader>k', ':m .-2<CR>==', noremap_options)
map('n', '<leader>j', ':m .+1<CR>==', noremap_options)
map('n', 'Y', 'y$', noremap_options)
map('n', 'n', 'nzz', noremap_options)

--My sensible remap for deleting words backwards
--This will delete the character under the cursor when deleting backwards
--Then it will place the cursor on the left of the single or double quotes
map('n', 'dT"', 'dT"dlh', noremap_options)
map('n', 'dT\'', 'dT\'dlh', noremap_options)
map('n', 'cT"', 'dT"dlha', noremap_options)
map('n', 'cT\'', 'dT\'dlha', noremap_options)

--Search with visually selected text
-- map('v', '//', 'y\\/V<C-R>=escape(@","/\")<CR><CR>', noremap_options)

--Fugitive Keybinding
-- map('n', '<leader>gn', ':diffget //3<CR>', {})
-- map('n', '<leader>gt', ':diffget //2<CR>', {})
map('n', '<leader>gs', ':G<CR>', {})

--Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', noremap_options)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', noremap_options)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', noremap_options)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', noremap_options)

--Emacs window hopping
map('n', '<leader>wh', ':wincmd h<CR>', noremap_options)
map('n', '<leader>wj', ':wincmd j<CR>', noremap_options)
map('n', '<leader>wk', ':wincmd k<CR>', noremap_options)
map('n', '<leader>wl', ':wincmd l<CR>', noremap_options)

--Window sizing
map('n', '<leader>+', ':vertical resize +5<CR>', noremap_options)
map('n', '<leader>-', ':vertical resize -5<CR>', noremap_options)

--Generate a UUID
map('i', '<c-u>', '<c-r>=trim(system(\'uuidgen\'))<cr>', noremap_options)

--Harpoon Key Bindings
map('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<cr>', noremap_options)
map('n', '<leader>hs', ':lua require("harpoon.ui").toggle_quick_menu()<cr>', noremap_options)
map('n', '<leader>hn', ':lua require("harpoon.ui").nav_file(1)<cr>', noremap_options)
map('n', '<leader>he', ':lua require("harpoon.ui").nav_file(2)<cr>', noremap_options)
map('n', '<leader>hi', ':lua require("harpoon.ui").nav_file(3)<cr>', noremap_options)
map('n', '<leader>ho', ':lua require("harpoon.ui").nav_file(4)<cr>', noremap_options)

--Dotfiles snippets
map('n', ',html', ':-1read $HOME/.dotfiles/skeletons/skeleton.html<CR>3jwf>a', noremap_options)
map('n', ',react', ':-1read $HOME/.dotfiles/skeletons/skeleton.jsx<CR>2j3wce', noremap_options)
map('n', ',vue', ':-1read $HOME/.dotfiles/skeletons/skeleton.vue<CR>ja', noremap_options)
map('n', ',csdto', ':-1read $HOME/.dotfiles/skeletons/csdto.cs<CR>4jwce', noremap_options)

--Open a new terminal within vim
map('n', '<leader>tt', ':vnew term://bash<CR>', noremap_options)

--Disable Escape p for Auto Pairs. Escape p trigger auto pairs to toggle
map('n', '<M-p>', '<Nop>', noremap_options)

--Color Swap keymapping
map('n', '<leader>cs', ':lua require("nvimcolorswap").hex2rgb()<CR>', noremap_options)

--Prettier
-- map('n', '<leader>p', ':Prettier<CR>', noremap_options)

--Setup the Emmet Leader key to comma
--Disable auto pairs shortcut toggling
vim.cmd [[
  let g:user_emmet_leader_key=','
  let g:AutoPairsShortcutToggle=''
]]

--TODO move these pieces to another file
--Pretty Fold
require('pretty-fold').setup{ }
require('pretty-fold.preview').setup {
   key = 'h', -- choose 'h' or 'l' key
}

require('lualine').setup{
  options = { theme = 'gruvbox' }
}

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world"
  },
  mappings = {}
}
