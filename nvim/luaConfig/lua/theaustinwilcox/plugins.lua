return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- this is essential.
  use "gruvbox-community/gruvbox"

  use "austinwilcox/pretty-fold.nvim"
  use "nvim-telescope/telescope.nvim"
  use "mattn/emmet-vim"
  use "dense-analysis/ale"
  use "nvim-lua/popup.nvim"
  use "ap/vim-css-color"

  -- nvim tree - File Explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- Harpoon
  use "nvim-lua/plenary.nvim"
  use "ThePrimeagen/harpoon"

  -- LSP Setup
  use "neovim/nvim-lspconfig"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/nvim-cmp"
  use "lukas-reineke/lsp-format.nvim"
  use { 'tjdevries/nlua.nvim', requires = { 'nvim-lua/completion-nvim', 'euclidianAce/BetterLua.vim' } }

  -- Snippet Managers
  use "SirVer/ultisnips"
  use "honza/vim-snippets"

  -- TPOPE
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  use "tpope/vim-commentary"
  use "tpope/vim-dotenv"

  -- Chentoast Marks - A better experience with Marks in NVIM
  use { 'chentoast/marks.nvim' }

  -- Prettier - Currently do not like any of the solutions
  -- use { 'prettier/vim-prettier', run = 'yarn install', ft = {'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'} }
  -- use { 'jose-elias-alvarez/null-ls.nvim' }
  -- use { 'MunifTanjim/prettier.nvim' }

  --Lualine
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt=true }}

  --Auto Pairs auto close ( [ {
  use { 'jiangmiao/auto-pairs' }

  --Rainbow for ( [ {  } ] )
  use { 'luochen1990/rainbow' }

  --Beautiful Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  --Plugins on my local machine
  use { '/home/austin/plugins/nvim-color-swap' }
end)
