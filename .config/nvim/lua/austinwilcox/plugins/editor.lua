return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({})
    end,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        -- Logseq task markers (merged with the built-in FIX/TODO/HACK/... keywords)
        keywords = {
          DOING = { icon = " ", color = "warning", alt = { "NOW" } },
          LATER = { icon = " ", color = "hint" },
          DONE = { icon = " ", color = "hint", alt = { "CANCELED", "CANCELLED" } },
        },
        highlight = {
          -- Logseq markers live in prose, not comments
          comments_only = false,
          pattern = {
            [[.*<(KEYWORDS)\s*:]], -- code comments: TODO:
            [[^\s*- (KEYWORDS)>]], -- Logseq blocks: - TODO ...
          },
        },
      })
    end,
  },

  { "folke/zen-mode.nvim", opts = {} },

  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({})
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = vim.keymap.set
        local opts = { buffer = bufnr }

        map("n", "]h", gs.next_hunk, opts)
        map("n", "[h", gs.prev_hunk, opts)
        map("n", "<leader>hp", gs.preview_hunk, opts)
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
        map("n", "<leader>hr", gs.reset_hunk, opts)
        map("n", "<leader>hR", gs.reset_buffer, opts)
        map("n", "<leader>hu", gs.undo_stage_hunk, opts)
      end,
    },
  },

}
