local script_dir = require("setup.utils.filesystem.script_dir")

---Walk upward from script directory to find the 'lua' module root
---@return string? lua_root Absolute path to lua/ directory
local function get_lua_root_dir()
  local dir = script_dir()

  while dir and dir ~= "/" do
    if dir:match("/lua/?$") then
      return dir
    end
    dir = dir:match("(.*/)[^/]+/?$") -- move one directory up
  end

  return nil
end

return get_lua_root_dir
