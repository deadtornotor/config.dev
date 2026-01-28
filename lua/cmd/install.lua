local utils = require("utils")

---@type cmd.Base
local M = utils.cmd.base:new("install", "Install for types", "[{<type>}, '*']")

function M:run(opts)
  if #opts.positional > 1 then
    utils.package_manager.update()
  end

  print(
    string.format("Positional: %s", table.concat(opts.positional, ","))
  )

  ---@param pack utils.Pack Callback for the package
  local function callback(pack)
    pack:install()
  end

  if not utils.cmd.positional_as_pack_type(opts, callback) then
    print("Please define a type to install for, use 'list' for all types")
    return false
  end

  return true
end

return M
