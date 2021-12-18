local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('nvim-treesitter/nvim-treesitter', {['do']=':TSUpdate'})
Plug 'neovim/nvim-lspconfig'
Plug 'rafcamlet/coc-nvim-lua'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dotenv'

Plug 'gruvbox-community/gruvbox'

Plug('prettier/vim-prettier', {['do']='yarn install', ['for'] = {'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'}})

Plug 'nvim-telescope/telescope.nvim'
Plug('dracula/vim', {as='dracula' })
Plug 'leafgarland/typescript-vim'
Plug('ternjs/tern_for_vim', { ['do'] = 'npm install' })
Plug 'preservim/nerdtree' 
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color' 
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'

Plug('neoclide/coc.nvim', {['do']= 'yarn install --frozen-lockfile'})
Plug 'sindrets/winshift.nvim'
Plug 'jiangmiao/auto-pairs' 
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'

vim.call('plug#end')
