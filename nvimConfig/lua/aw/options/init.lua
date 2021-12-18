vim.g.mapleader = " "
vim.o.syntax = "on"
vim.o.clipboard='unnamedplus'
vim.o.wrap = false
vim.o.colorcolumn='80'
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.showmatch = true
vim.o.showcmd = true
vim.o.expandtab = true
vim.o.noerrorbells = true

vim.cmd='highlight ColorColumn ctermbg=7'


vim.cmd=[[
set nowrap
set noswapfile
set nobackup
set incsearch
set smartindent
set showmatch
set wildmenu
set autoindent
set relativenumber
set nu
set hidden
set undodir=~/.vim/undodir
set undofile
set signcolumn=yes
set modifiable
set encoding=UTF-8
filetype indent on
set colorcolumn=80
highlight ColorColumn ctermbg=7

filetype plugin on
set omnifunc=syntaxcomplete#Complete
]]
