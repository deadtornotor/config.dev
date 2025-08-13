local packs = require("utils.packs")

require("core.os")

local M = {}

--- Index the configurations
--- Only indexes configurations connected to the os parameters
function M.index_configs()
  local pack_config = {}
  local configs = require("config.packs")

  for _, module_name in ipairs(configs) do
    ---@type boolean, utils.PackConfigRegister
    local ok, module = pcall(require, module_name)

    if not ok then
      print(
        string.format("Could not load %s: %s", ok, module)
      )
    end

    if not packs.is_valid_registry(module) then
      print(
        string.format("Could not index %s: invalid configuration", module_name)
      )
      goto continue
    end

    if os_config.os_id ~= module.os then
      goto continue
    end

    if module.wsl then
      if os_config.is_wsl ~= module.wsl then
        goto continue
      end
    end

    table.insert(pack_config, module)

    ::continue::
  end

  ---@type utils.PackConfigRegister[]
  _G.pack_configs = pack_config
end

M.index_configs()

function M.types()
  local types = {}

  for _, config in ipairs(_G.pack_configs) do
    local config_types = config.types

    table.move(config_types, 1, #config_types, #types + 1, types)
  end

  return types
end

return M
