return {
  {
    "austinwilcox/jsonhero.nvim",
    event = "VeryLazy",
    config = function()
      require("jsonhero").setup({})
    end,
  },

  {
    "austinwilcox/ZKMoveFile",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("ZKMoveFile").setup({
        dir = "/home/austin/Zettelkasten-V2",
        permanent_notes_dir = "Permanent Notes",
        title = "ZK Directories",
        layers = 1,
      })
    end,
  },

  { "github/copilot.vim" },

  { "R-nvim/R.nvim", lazy = false },

  {
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = "DocsViewToggle",
    opts = { position = "bottom" },
  },

  {
    "austinwilcox/hex2rgba",
    event = "VeryLazy",
    keys = {
      { "<leader>cs", function() require("hex2rgba").hex2rgba() end, desc = "Hex to RGBA" },
    },
  },
}
