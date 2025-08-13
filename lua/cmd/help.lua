local Base = require("cmd.base")

---@type cmd.Base
local M = Base:new("help", "Show help for all available commands", "<cmd>")

function M:run(opts)
  local modules = require("config.cmd")
  local target_cmd = opts and opts.optional and opts.positional[2]

  print()

  if target_cmd then
    -- Try to load the specific command
    local ok, cmd = pcall(require, "cmd." .. target_cmd)
    if not ok or not cmd then
      print("Unknown command: " .. target_cmd)
      print()
      return false
    end

    if type(cmd.long_help) == "function" then
      cmd:long_help()
    elseif type(cmd.help) == "function" then
      cmd:help()
    else
      print("No help available for command: " .. target_cmd)
    end

    print()
    return true
  end

  -- Otherwise, list all commands with short help
  for _, module_name in ipairs(modules) do
    local ok, mod = pcall(require, "cmd." .. module_name)

    if not ok or not mod then
      goto continue
    elseif type(mod.help) ~= "function" then
      goto continue
    end

    mod:help()

    ::continue::
  end

  print()
  return true
end

return M
