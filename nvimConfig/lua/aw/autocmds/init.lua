local M = {}
function M.autocmd(event, triggers, operations)
  local cmd = string.format("autocmd %s %s %s", event, triggers, operations)
  vim.cmd(cmd)
end

M.autocmd("BufNewFile,BufRead", "*.cs", "set formatprg=astyle\\ -T4pb")
M.autocmd("BufEnter", "*", "if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | \\ quit | endif")

return M
