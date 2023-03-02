return require'packer'.startup(function(use)
  use 'wbthomason/packer.nvim' -- this is essential.

  -- Colorschemes
  use { 'Mofiqul/dracula.nvim' }
  use "gruvbox-community/gruvbox"
  use "EdenEast/nightfox.nvim"
  use "folke/tokyonight.nvim"

  -- To get Telescope live grep working you need ripgrep
  -- Ubuntu/Debian based
  -- sudo apt install ripgrep
  use "nvim-telescope/telescope.nvim"
  use "mattn/emmet-vim"
  use "dense-analysis/ale"
  use "nvim-lua/popup.nvim"
  use "ap/vim-css-color"

  -- Colorizer, provided color highlights
  use { 'norcalli/nvim-colorizer.lua' }

  -- NVIM Todo Comments
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup{}
    end
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
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use { 'tjdevries/nlua.nvim', requires = { 'nvim-lua/completion-nvim', 'euclidianAce/BetterLua.vim' } }
  use { 'onsails/lspkind.nvim' } -- Vscode like pictograms

  -- Snippet Managers
  use "SirVer/ultisnips"
  use "honza/vim-snippets"

  -- NVIM Dap
  -- use "mfussenegger/nvim-dap"

  -- TPOPE
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  use "tpope/vim-commentary"
  use "tpope/vim-dotenv"

  -- GIT
  use "mhinz/vim-signify"
  use "junegunn/gv.vim"

  -- Chentoast Marks - A better experience with Marks in NVIM
  use { 'chentoast/marks.nvim' }

  -- Prettier - Currently do not like any of the solutions
  -- use { 'prettier/vim-prettier', run = 'yarn install', ft = {'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'} }
  -- use { 'jose-elias-alvarez/null-ls.nvim' }
  -- use { 'MunifTanjim/prettier.nvim' }

  --Lualine
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt=true }}

  --Rainbow for ( [ {  } ] )
  use { 'luochen1990/rainbow' }

  --Beautiful Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  --Plugins on my local machine
  -- use { '/home/austin/plugins/nvim-color-swap' }
  -- use { '/home/austin/plugins/nvim-keybind-snippet' }
  -- use { '/home/austin/plugins/nvim-surround' }

  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  })

  --Goto Preview, use lsp and show information in a popup window
  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  }

  -- Deno support
  -- Currently this interferes way to much with tsserver
  -- use 'sigmasd/deno-nvim'

  -- Removing it here so that I can use the main branch version to test
  -- use { 'kylechui/nvim-surround', tag = "*" }

end)
