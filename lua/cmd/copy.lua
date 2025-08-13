local utils = require("utils")

---@type cmd.Base
local M = utils.cmd.base:new("copy", "Copy dotfiles", "[{<type>}, *]")

function M:run(opts)
  if #opts.positional > 1 and opts.positional[2] == "*" then
    utils.fs.copy_dots()
    return
  end

  ---@param pack utils.Pack Callback for the package
  local function callback(pack)
    pack:copy()
  end

  if not utils.cmd.positional_as_pack_type(opts, callback) then
    print("Please define a type to install for, use 'list' for all types")
    return false
  end

  return true
end

return M
