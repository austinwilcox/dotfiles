return {
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
  { "sainnhe/everforest", lazy = false, priority = 1000 },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000 },
  { "mofiqul/dracula.nvim", lazy = false, priority = 1000 },
  { "shaunsingh/nord.nvim", lazy = false, priority = 1000 },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-storm")
    end,
  },
}
