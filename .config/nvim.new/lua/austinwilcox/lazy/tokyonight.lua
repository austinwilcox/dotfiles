  return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colorscheme = "tokyonight-storm"
      local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
      if not status_ok then
        vim.notify("colorscheme " .. colorscheme .. " not found!")
        return
      end
    end,
  }
