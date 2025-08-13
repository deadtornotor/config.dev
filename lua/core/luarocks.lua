local pm = require("utils.package_manager")

---@class core.LuaRocks
local M = {}

--- List of LuaRocks packages to ensure are installed
M.required_rocks = {
  "luafilesystem",
}

--- Ensure LuaRocks is installed via the system package manager
local function ensure_luarocks_installed()
  local ok = os.execute("luarocks --version > /dev/null 2>&1")
  if ok == true or ok == 0 then
    return true
  end

  print("==> LuaRocks not found, installing...")
  pm.install({
    "luarocks",
  })
  return os.execute("luarocks --version > /dev/null 2>&1") == true
end

--- Ensure a specific LuaRocks package is installed
---@param rock string
local function ensure_rock_installed(rock)
  local ok = os.execute(string.format("luarocks show %s > /dev/null 2>&1", rock))
  if ok == true or ok == 0 then
    return
  end

  print(string.format("==> Installing LuaRocks package: %s", rock))
  local res = os.execute(string.format("luarocks install %s", rock))
  if res ~= true and res ~= 0 then
    error(string.format("Failed to install LuaRocks package: %s", rock))
  end
end

--- Main setup checker
function M.setup()
  if not ensure_luarocks_installed() then
    error("Could not install LuaRocks — aborting")
    return
  end

  for _, rock in ipairs(M.required_rocks) do
    local modname = rock == "luafilesystem" and "lfs" or rock
    local ok, _ = pcall(require, modname)
    if not ok then
      ensure_rock_installed(rock)
    end
  end
end

-- Run on require
M.setup()

return M
