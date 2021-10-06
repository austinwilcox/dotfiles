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
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dotenv'

" Prettier code formatter for web dev stack
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'leafgarland/typescript-vim'
Plug 'mbbill/undotree'
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
Plug 'preservim/nerdtree' | 
  \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color' " Color previews for CSS
Plug 'OmniSharp/omnisharp-vim'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting
Plug 'sindrets/winshift.nvim'
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier']  " list of CoC extensions needed
Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {
" these two plugins will add highlighting and indenting to JSX and TSX files.
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'shadmansaleh/lualine.nvim'
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none
set background=dark

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

" Coc GoTo Code Navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Vim Fugitive keybindings
nmap <leader>gn :diffget //3<CR>
nmap <leader>gt :diffget //2<CR>
nmap <leader>gs :G<CR>

" Nerd Tree Bindings "
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Custom convert hex to rgba
nnoremap <leader>cs :call v:lua.hex2rgb()<CR>

" Indent JSON files on save - experimental
autocmd FileType json autocmd BufWritePre <buffer> %!python -m json.tool

" Snippets in my dotfiles folder
nnoremap ,html :-1read $HOME/.dotfiles/skeletons/skeleton.html<CR>3jwf>a
nnoremap ,react :-1read $HOME/.dotfiles/skeletons/skeleton.jsx<CR>2j3wce
nnoremap ,vue :-1read $HOME/.dotfiles/skeletons/skeleton.vue<CR>ja
nnoremap ,csdto :-1read $HOME/.dotfiles/skeletons/csdto.cs<CR>4jwce

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Open terminal inside Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>tt :vnew term://bash<CR>
:tnoremap <Esc> <C-\><C-n>

autocmd BufNewFile,BufRead *.cs set formatprg=astyle\ -T4pb

" Exit Vim if NERDTree is the only window left "
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

lua <<EOF
require('lualine').setup {
    options = { theme = 'dracula' }
  }
EOF

lua <<EOF
function _G.hex2rgb()
  local r,c = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0,r-1,r,false)
  local line = unpack(lines)
  local beginningindexofhexcode = string.find(line, '#%x%x%x%x%x')
  local length = 6
  if beginningindexofhexcode == nil then
    beginningindexofhexcode = string.find(line, '#%x%x%x')
    length = 3
    if beginningindexofhexcode == nil then
      return ''
    end
  end
  local hexcode = string.sub(line, beginningindexofhexcode, beginningindexofhexcode + length)
  local rgba = getrgbafromhex(hexcode)
  vim.api.nvim_buf_set_text(0,r-1,beginningindexofhexcode -1,r-1,beginningindexofhexcode + hexcode:len() -1,{rgba})
  return ''
end

function getrgbafromhex(hex)
  local hexwithnopoundsign = hex:gsub("#","")
  local red, green, blue
  if hexwithnopoundsign:len() == 3 then
    red = tonumber("0x"..hexwithnopoundsign:sub(1,1)) * 17
    green = tonumber("0x"..hexwithnopoundsign:sub(2,2)) * 17
    blue = tonumber("0x"..hexwithnopoundsign:sub(3,3)) * 17
  else
    red = tonumber("0x"..hexwithnopoundsign:sub(1,2))
    green = tonumber("0x"..hexwithnopoundsign:sub(3,4))
    blue = tonumber("0x"..hexwithnopoundsign:sub(5,6))
  end
  local rgba = "rgba(" .. tostring(red) ..  "," .. tostring(green) .. "," .. blue ..",1.0)"

  return rgba
end
EOF


