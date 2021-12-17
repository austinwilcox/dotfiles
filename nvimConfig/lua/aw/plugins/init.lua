vim.cmd([[
call plug#begin('~/.config/nvim/plugged')
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
"Plug 'neovim/nvim-lspconfig'

Plug 'rafcamlet/coc-nvim-lua'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dotenv'

Plug 'gruvbox-community/gruvbox'

" Prettier code formatter for web dev stack
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

Plug 'nvim-telescope/telescope.nvim'
Plug 'dracula/vim', { 'as':'dracula' }
Plug 'leafgarland/typescript-vim'
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
Plug 'preservim/nerdtree' | 
  \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color' " Color previews for CSS
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting
Plug 'sindrets/winshift.nvim'
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier']  " list of CoC extensions needed
Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {
" these two plugins will add highlighting and indenting to JSX and TSX files.
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
call plug#end()

]])
