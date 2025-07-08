local Base = require("setup.command.Base")
local utils = require("setup.utils")

---@type setup.command.Base
local M = {}
for k, v in pairs(Base) do
  M[k] = v
end

M.name = "install"
M.usage = "[{<types>}, *]"
M.description = "Install targets by type"

function M:run(opts)
  return true
end

return M
