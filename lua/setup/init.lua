local M = {}

--- @class setup.Options
--- @field positional table
--- @field optional table

---@type setup.command.Base
local help_command = require("setup.command.help")

---Run setup
---@param opts setup.Options
function M.run(opts)
  local command_name = opts.positional and opts.positional[1]

  if not command_name then
    help_command:run()
    return
  end

  local ok, command = pcall(require, "setup.command." .. command_name)
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
