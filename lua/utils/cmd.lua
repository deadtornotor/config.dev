local base = require("cmd.base")
local pack = require("core.pack")
local packs = require("utils.packs")

local M = {}

M.base = base

---Use positional arguments as type names and callback each
---@param opts core.Options Options
---@param callback fun(pack: utils.Pack) Callback for the package
---@return boolean Success Returns true if it succeded
function M.positional_as_pack_type(opts, callback)
  if #opts.positional < 2 then
    return false
  end

  local function for_type(name)
    local pack_type = packs:new(name)

    if pack_type == nil then
      print(string.format(
        "Unknown type: %s", name)
      )
      return
    end

    callback(pack_type)
  end

  -- if '*' e.g. All
  if opts.positional[2] == "*" then
    for _, name in ipairs(pack.types()) do
      for_type(name)
    end
    return true
  end

  for i = 2, #opts.positional do
    local name = opts.positional[i]

    for_type(name)
  end

  return true
end

return M
