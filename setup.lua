-- Set up the Lua module
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

-- Require your setup module
local setup = require("setup")

-- Parse flags manually
local options = {}
local positional = {}

for _, v in ipairs(arg) do
  if v:match("^%-%-") then
    local key = v:match("^%-%-(.+)")
    options[key] = true
  else
    table.insert(positional, v)
  end
end

-- Dispatch
if options["dry-run"] then
  setup.dry_run()
elseif positional[1] == "run" then
  setup.run()
else
  setup.help()
end
