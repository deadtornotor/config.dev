local M = {}

--- Check if windows
---@return boolean success If windows
function M.is_windows()
  return package.config:sub(1, 1) == "\\"
end

return M
