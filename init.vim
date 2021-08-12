syntax on
set noerrorbells
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
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
set clipboard=unnamedplus       " Copy/paste between vim and other programs.

filetype indent on

set colorcolumn=80
highlight ColorColumn ctermbg=7

"-- Auto Completion --"
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"--Plugins (using junegunn/vim-plug --"
call plug#begin('~/.vim/autoload/vim.plug')
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'git@github.com:ycm-core/YouCompleteMe.git'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mbbill/undotree'
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
Plug 'preservim/nerdtree' | 
  \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'                            " Color previews for CSS
Plug 'OmniSharp/omnisharp-vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting

let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier']  " list of CoC extensions needed

Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

" these two plugins will add highlighting and indenting to JSX and TSX files.
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none

let mapleader = " "
nnoremap <leader>wh :wincmd h<CR>
nnoremap <leader>wj :wincmd j<CR>
nnoremap <leader>wk :wincmd k<CR>
nnoremap <leader>wl :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<SPACE>
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>

" YCM
nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>

" Nerd Tree Bindings "
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
"Turned this one off because it interferes with using ctrl+f and ctrl+b to make larger file jumps"
" nnoremap <C-f> :NERDTreeFind<CR> "

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Open terminal inside Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>tt :vnew term://bash<CR>

" Exit Vim if NERDTree is the only window left "
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
