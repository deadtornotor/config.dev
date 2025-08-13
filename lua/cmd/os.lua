local Base = require("cmd.base")

---@type cmd.Base
local M = Base:new("os", "Show os information")

function M:run(opts)
  local lines = {
    string.format("ID:    %s", os_config.os_id),
    string.format("Name:  %s", os_config.os_name),
    string.format("WSL:   %s", os_config.is_wsl),
  }

  print(table.concat(lines, "\n"))
  return true
end

return M
