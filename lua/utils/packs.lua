---@class utils.PackConfig
---@field dots string[]? List of dotfile directories/files
---@field packs string[]? Packages of package manager
---@field setup fun(): boolean? Setup function for packages

---@class utils.PackConfigRegister
---@field os string The os string for which this is used
---@field module string The module path in which the types are stored
---@field wsl boolean? Is for wsl
---@field types string[] The different types

local manager = require("utils.package_manager")
local array = require("utils.array")

---@class utils.Pack
---@field name string Name of package
local M = {}

M.__index = M

--- Create a new command object
---@param name string Name of command
---@return utils.Pack|nil Package Returns nil if not known
function M:new(name)
  assert(type(name) == "string", "Name not string")

  local pack = require("core.pack")

  if not array.contains(pack.types(), name) then
    return nil
  end

  local self = setmetatable({}, M)
  self.name = name
  return self
end

---Get the pack config
---@param base_module string Base module
---@param name string Module name
---@return utils.PackConfig|nil
local function require_mod(base_module, name)
  assert(type(base_module) == "string", "Base module name not string")
  assert(type(name) == "string", "Name not string")

  local module_name = base_module .. "." .. name
  local ok, mod = pcall(require, module_name)

  if not ok then
    print(
      string.format("Could not load package %s from %s: %s", name, module_name, mod)
    )
    return nil
  end

  return mod
end

function M:install()
  if os_config.os_id == "windows" then
    print("Not implemented for os")
    return
  end

  ---@param mod utils.PackConfig
  local function callback(mod)
    if not mod.packs then
      return
    end

    if _G.dry_run then
      print("Would install:\n", table.concat(mod.packs, "\n"))
      return
    end

    manager.install(mod.packs)
  end

  self:for_each(callback)
end

function M:setup()
  if os_config.os_id == "windows" then
    print("Not implemented for os")
    return
  end

  ---@param mod utils.PackConfig
  ---@param config utils.PackConfigRegister
  local function callback(mod, config)
    if not mod.setup then
      return
    end

    assert(type(mod.setup) == "function",
      string.format("%s Setup function is not a function, located in %s", self.name, config.module))


    if _G.dry_run then
      print("Would setup: ", self.name)
      return
    end

    mod.setup()
  end

  self:for_each(callback)
end

function M:copy()
  if os_config.os_id == "windows" then
    print("Not implemented for os")
    return
  end

  ---@param mod utils.PackConfig
  ---@param config utils.PackConfigRegister
  local function callback(mod, config)
    if not mod.dots then
      return
    end

    assert(type(mod.dots) == "table",
      string.format("%s dots is not a table, located in %s", self.name, config.module))


    if _G.dry_run then
      print("Would copy dots:\n", table.concat(mod.dots, "\n"))
      return
    end

    local fs = require("utils.fs")

    fs.copy_dots(mod.dots)
  end

  self:for_each(callback)
end

function M:info()
  ---@param mod utils.PackConfig
  ---@param config utils.PackConfigRegister
  local function callback(mod, config)
    local lines = {
      "==============================",
      string.format("Names:         %s", self.name),
      string.format("Config module: %s", config.module),
      string.format("OS:            %s", config.os),
    }

    if config.wsl == nil then
      table.insert(lines, string.format('WSL:           N/A'))
    else
      table.insert(lines, string.format("WSL:           %s", config.wsl))
    end

    if mod.dots then
      local dotfiles = table.concat(mod.dots, ";")
      table.insert(lines, string.format("Dotfiles:      %s", dotfiles))
    end

    if mod.packs then
      local packages = table.concat(mod.packs, " ")
      table.insert(lines, string.format("Packages:      %s", packages))
    end

    print(table.concat(lines, "\n"))
  end

  self:for_each(callback)
end

---For each types
---@param func fun(pack: utils.PackConfig, config: utils.PackConfigRegister)
function M:for_each(func)
  for _, config in ipairs(_G.pack_configs) do
    if not array.contains(config.types, self.name) then
      goto continue
    end

    local mod = require_mod(config.module, self.name)

    if mod == nil then
      goto continue
    end

    func(mod, config)

    ::continue::
  end
end

function M.is_valid_registry(obj)
  if type(obj) ~= "table" then
    return false
  end
  if type(obj.os) ~= "string" then
    return false
  end

  if type(obj.module) ~= "string" then
    return false
  end

  if type(obj.types) ~= "table" then
    return false
  end

  for _, v in ipairs(obj.types) do
    if type(v) ~= "string" then
      return false
    end
  end

  return true
end

return M
