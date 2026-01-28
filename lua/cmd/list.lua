local pack = require("core.pack")
local utils = require("utils")

---@type cmd.Base
local M = utils.cmd.base:new("list", "List all types")

function M:run(opts)
  local types = pack.types()

  print("==> Types <==")
  print(table.concat(types, "\n"))
  return true
end

return M
