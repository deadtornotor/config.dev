local Base = require("setup.command.Base")
local utils = require("setup.utils")

---@type setup.command.Base
local M = {}
for k, v in pairs(Base) do
  M[k] = v
end

M.name = "help"
M.usage = ""
M.description = "Show help for all available commands"

function M:run(opts)
  local path = utils.fs.lua_root_dir() .. "/setup/command"
  local base_name = "Base.lua"

  local files = utils.fs.list_files(path, function(f)
    return f:match("%.lua$") and f ~= base_name
  end)

  print()

  for __, file in ipairs(files) do
    local mod_name = file:sub(1, -5) -- strip .lua
    local ok, mod = pcall(require, "setup.command." .. mod_name)

    if not ok or not mod then
      goto continue
    elseif not (type(mod.help) == "function") then
      goto continue
    end

    mod:help()

    ::continue::
  end

  print()

  return true
end

return M
