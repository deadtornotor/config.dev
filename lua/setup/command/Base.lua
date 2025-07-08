---@class setup.command.Base
---@field name string Name of command
---@field usage? string Usage of command
---@field description string Description of command
local M = {
  name = "Base",
  usage = nil,
  description = "This is the base command",
}

--- Runs the commands action
---@param opts setup.Options Options given to the command
---@return boolean success If command was successfull
function M:run(opts)
  opts = opts or {}
  print("You are running the base command")
  return false
end

--- Display help for the command
function M:help()
  local left = "   " .. self.name .. " " .. (self.usage or "")
  local right = self.description
  local padding = 30 -- total left column width

  -- Pad right side to align description
  local spaces = padding - #left
  if spaces < 1 then
    spaces = 1
  end

  print(left .. string.rep(" ", spaces) .. right)
end

--- Display long help for the command
function M:long_help()
  print(
    table.concat({
        "Command:     " .. self.name,
        "Usage:       " .. (self.usage or "N/A"),
        "Description: " .. self.description,
      },
      "\n"
    )
  )
end

return M
