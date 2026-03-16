return {
  "rmagatti/goto-preview",
  config = function()
    require("goto-preview").setup({
      width = 120,
      height = 30,
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
      default_mappings = false,
      focus_on_open = true,
      dismiss_on_move = false,
      force_close = true,
      bufhidden = "wipe",
    })

    local gp = require("goto-preview")
    vim.keymap.set("n", "gpd", gp.goto_preview_definition, { noremap = true })
    vim.keymap.set("n", "gpt", gp.goto_preview_type_definition, { noremap = true })
    vim.keymap.set("n", "gpi", gp.goto_preview_implementation, { noremap = true })
    vim.keymap.set("n", "gP", gp.close_all_win, { noremap = true })
    vim.keymap.set("n", "gpr", gp.goto_preview_references, { noremap = true })
  end,
}
