local themes = {
  "rose-pine",
  "tokyonight-storm",
  "everforest",
  "cyberdream",
  "dracula",
  "nord",
}

return {
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "sainnhe/everforest", lazy = false, priority = 1000 },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000 },
  { "mofiqul/dracula.nvim", lazy = false, priority = 1000 },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      math.randomseed(os.time())
      local choice = themes[math.random(#themes)]
      local ok, _ = pcall(vim.cmd, "colorscheme " .. choice)
      if ok then
        vim.notify("Colorscheme: " .. choice)
      else
        vim.notify("Failed to load colorscheme: " .. choice, vim.log.levels.WARN)
      end
    end,
  },
}
