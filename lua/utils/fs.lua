local M = {}

local lfs = require("lfs")
M.lfs = lfs

local home = os.getenv("HOME")
if not home then error("Could not determine HOME directory") end
M.home = home

local function get_script_dir()
  local source = debug.getinfo(2, "S").source -- 2 = caller of this function
  if source:sub(1, 1) == "@" then
    local path = source:sub(2)
    path = path:gsub("\\", "/") -- normalize for Windows
    return path:match("(.*/)")
  end
  return nil
end

local function resolve_path(path)
  -- Expand ~
  if path:sub(1, 1) == "~" then
    path = home .. path.sub(2)
  end

  -- Make absolute
  if not path:match("^/") then
    local cwd = lfs.currentdir()
    path = cwd .. "/" .. path
  end

  -- Normalize
  local parts = {}
  for part in path:gmatch("[^/]+") do
    if part == ".." then
      if #parts > 0 then
        table.remove(parts)
      end
    elseif part ~= "." and part ~= "" then
      table.insert(parts, part)
    end
  end

  return "/" .. table.concat(parts, "/")
end

local dots_dir = function()
  local dir = get_script_dir()

  dir       = dir .. "/../../linux/dots"

  dir       = resolve_path(dir)

  return dir
end


local function file_exists(path)
  local attr = lfs.attributes(path)
  return attr and attr.mode == "file"
end

-- Ensure a directory exists (creates it recursively if needed)
local function ensure_dir(path)
  local attr = lfs.attributes(path)
  if attr and attr.mode == "directory" then return end
  -- Recursively create parent first
  local parent = path:match("^(.*)/[^/]+$")
  if parent and parent ~= "" then
    ensure_dir(parent)
  end
  assert(os.execute(string.format('mkdir -p "%s"', path)), "Failed to create directory: " .. path)
end

-- Copy a file from src to dest
local function copy_file(src, dest)
  local in_f = assert(io.open(src, "rb"), "Cannot open source: " .. src)
  ensure_dir(dest:match("^(.*)/[^/]+$") or home)
  local out_f = assert(io.open(dest, "wb"), "Cannot open destination: " .. dest)
  out_f:write(in_f:read("*a"))
  in_f:close()
  out_f:close()
  print("Copied " .. src .. " -> " .. dest)
end

-- Recursively copy a path
local function copy_path(src_path, dest_path)
  local attr = lfs.attributes(src_path)
  if not attr then return end

  if attr.mode == "file" then
    copy_file(src_path, dest_path)
  elseif attr.mode == "directory" then
    ensure_dir(dest_path)
    for entry in lfs.dir(src_path) do
      if entry ~= "." and entry ~= ".." then
        local sub_src = src_path .. "/" .. entry
        local sub_dest = dest_path .. "/" .. entry
        copy_path(sub_src, sub_dest)
      end
    end
  end
end

-- Main function: copy list or everything
local function copy_dots(paths)
  if not paths or #paths == 0 then
    -- Copy everything from source_dir to home
    for entry in lfs.dir(dots_dir()) do
      if entry ~= "." and entry ~= ".." then
        local src = dots_dir() .. "/" .. entry
        local dest = home .. "/" .. entry
        copy_path(src, dest)
      end
    end
  else
    -- Copy only given paths
    for _, rel_path in ipairs(paths) do
      local src = dots_dir() .. "/" .. rel_path
      local dest = home .. "/" .. rel_path
      copy_path(src, dest)
    end
  end
end

M.dots_dir = dots_dir()
M.get_script_dir = get_script_dir
M.file_exists = file_exists
M.ensure_dir = ensure_dir
M.copy_file = copy_file
M.copy_path = copy_path
M.copy_dots = copy_dots

return M
