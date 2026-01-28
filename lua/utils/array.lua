local M = {}

function M.contains(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

function M.remove_duplicates(tbl)
  local seen = {}
  local result = {}
  for _, v in ipairs(tbl) do
    if not seen[v] then
      seen[v] = true
      table.insert(result, v)
    end
  end
  return result
end

return M
