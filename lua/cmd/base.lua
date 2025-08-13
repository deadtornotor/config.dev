---@class cmd.Base
---@field name string Name of command
---@field description? string Description of command
---@field usage? string Usage of command
local M = {
  name = "Base",
  description = "This is the base command",
  usage = nil,
}

M.__index = M

--- Create a new command object
---@param name string Name of command
---@param description string? Description of command
---@param usage string? Usage of command
---@return cmd.Base
function M:new(name, description, usage)
  local self = setmetatable({}, M)
  self.name = name
  self.description = description
  self.usage = usage
  return self
end

--- Runs the commands action
---@param opts core.Options? Options given to the command
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
  if spaces < 1 then spaces = 1 end

  print(left .. string.rep(" ", spaces) .. right)
end

--- Display long help for the command
function M:long_help()
  local lines = {
    string.format("Command:     %s", self.name),
    string.format("Usage:       %s %s", self.name, self.usage or ""),
    string.format("Description: %s", self.description or "N/A"),
  }

  print(table.concat(lines, "\n"))
end

return M
