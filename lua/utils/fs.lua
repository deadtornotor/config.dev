local M = {}

local lfs = require("lfs")

function M.get_script_dir()
  local source = debug.getinfo(2, "S").source -- 2 = caller of this function
  if source:sub(1, 1) == "@" then
    local path = source:sub(2)
    path = path:gsub("\\", "/") -- normalize for Windows
    return path:match("(.*/)")
  end
  return nil
end

return M
