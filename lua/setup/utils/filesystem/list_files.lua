local lfs = require("lfs")

---List all files in a directory with optional filter
---@param path string
---@param filter? fun(filename:string):boolean
---@return string[] files
local function list_files(path, filter)
  local files = {}
  for file in lfs.dir(path) do
    if file == "." or file == ".." then
      goto continue
    end

    local f = path .. "/" .. file
    local attr = lfs.attributes(f)

    if attr.mode == "directory" then
      goto continue
    end

    if not filter or filter(file) then
      table.insert(files, file)
    end

    ::continue::
  end

  return files
end

return list_files
