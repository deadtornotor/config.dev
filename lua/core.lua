local M = {}

---@class core.Options
--- @field positional table
--- @field optional table

---@type cmd.Base
local help_command = require("cmd.help")

local rocks_ensure = require("core.luarocks")

require("core.os")
require("core.pack")

---Run setup
---@param opts core.Options
function M.run(opts)
  rocks_ensure.setup()

  local arrays = require("utils.array")

  if opts.optional["dry_run"] ~= nil then
    print("Performing dry_run")
    _G.dry_run = true
  else
    _G.dry_run = false
  end

  print(require("utils.fs").dots_dir)

  local command_name = opts.positional and opts.positional[1]

  if not command_name then
    help_command:run()
    return
  end

  local ok, command = pcall(require, "cmd." .. command_name)
  if not ok then
    print("Unknown command: " .. command_name)
    help_command:run()
    return
  end

  if type(command.run) == "function" then
    if not command:run(opts) then
      command:long_help()
    end
  else
    print("Command '" .. command_name .. "' does not implement run()")
  end
end

return M
