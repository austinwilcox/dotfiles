local M = {}

function M.OS()
  return package.config:sub(1,1) == "\\" and "win" or "unix"
end

return M
