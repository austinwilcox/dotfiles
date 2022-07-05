return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- this is essential.
  use "gruvbox-community/gruvbox"

  use "austinwilcox/pretty-fold.nvim"
  use "nvim-telescope/telescope.nvim"
  use "mattn/emmet-vim"
  use "dense-analysis/ale"
  use "nvim-lua/popup.nvim"
  use "ap/vim-css-color"

  -- Harpoon
  use "nvim-lua/plenary.nvim"
  use "ThePrimeagen/harpoon"

  -- LSP Setup
  use "neovim/nvim-lspconfig"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/nvim-cmp"
  use "lukas-reineke/lsp-format.nvim"

  -- Snippet Managers
  use "SirVer/ultisnips"
  use "honza/vim-snippets"

  -- Language Servers
  use "ray-x/go.nvim"

  -- TPOPE
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  use "tpope/vim-commentary"
  use "tpope/vim-dotenv"

  --Lualine
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt=true }}

  --Auto Pairs auto close ( [ {
  use { 'jiangmiao/auto-pairs' }
end)
