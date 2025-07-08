local function normalize(path)
  return path:gsub("\\", "/")
end

---Get the absolute directory of the script calling this function
---@return string
local function get_script_dir()
  local info = debug.getinfo(2, "S")
  local source = info and info.source
  if source and source:sub(1, 1) == "@" then
    return normalize(source:match("@(.*/)"))
  else
    return normalize("./")
  end
end


return get_script_dir
