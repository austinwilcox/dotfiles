local M = {}

function M.OS()
  return package.config:sub(1,1) == "\\" and "win" or "unix"
end

function M.IsUnix()
  return M.OS() == "unix"
end

function M.IsWindows()
  return M.OS() == "win"
end

return M
