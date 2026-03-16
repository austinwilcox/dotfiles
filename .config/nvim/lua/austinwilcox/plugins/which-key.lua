return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git / LSP" },
      { "<leader>h", group = "Harpoon / Hunks" },
      { "<leader>w", group = "Window" },
      { "<leader>z", group = "Zettelkasten" },
      { "<leader>c", group = "Code" },
      { "g", group = "Go to" },
    })
  end,
}
