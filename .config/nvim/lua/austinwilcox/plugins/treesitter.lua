return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  opts = {
    auto_install = true,
    ensure_installed = {
      "bash", "c_sharp", "clojure", "css", "go", "html",
      "javascript", "json", "lua", "markdown", "markdown_inline",
      "python", "r", "rnoweb", "regex", "rust", "scss", "sql",
      "tsx", "typescript", "vim", "yaml",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = { enable = true, disable = { "yaml" } },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ii"] = "@conditional.inner",
          ["ai"] = "@conditional.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
          ["at"] = "@comment.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
        goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
        goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
      },
      swap = {
        enable = true,
        swap_next = { ["<leader>a"] = "@parameter.inner" },
        swap_previous = { ["<leader>A"] = "@parameter.inner" },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
  end,
}
