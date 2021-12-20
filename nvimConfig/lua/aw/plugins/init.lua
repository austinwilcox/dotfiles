local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug('nvim-treesitter/nvim-treesitter', {['do']=':TSUpdate'})
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
