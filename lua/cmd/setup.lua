local utils = require("utils")

---@type cmd.Base
local M = utils.cmd.base:new("setup", "Run setup function for types", "[{<type>}, '*']")

function M:run(opts)
  ---@param pack utils.Pack Callback for the package
  local function callback(pack)
    pack:setup()
  end

  if not utils.cmd.positional_as_pack_type(opts, callback) then
    print("Please define a type to call setup for, use 'list' for all types")
    return false
  end

  return true
end

return M
