vim.g.loaded_matchparen = 1

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.hidden = true
vim.opt.errorbells = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true

vim.opt.wildmenu = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "UTF-8"
vim.opt.modifiable = true
vim.opt.background = "dark"
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Options that I don't know how to toggle with lua
vim.cmd [[
  syntax on
  highlight Normal guibg=none

  filetype indent on
  filetype plugin on
  " ALE: {{{
  let g:ale_sign_error = '•'
  let g:ale_sign_warning = '•'
  let g:ale_sign_info = '·'
  let g:ale_sign_style_error = '·'
  let g:ale_sign_style_warning = '·'

  let g:ale_linters = { 'cs': ['OmniSharp'] }
  " }}}
]]


