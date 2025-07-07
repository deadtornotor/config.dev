local M = {}

function M.run(opts)
  print("Running project module!")
end

function M.dry_run(opts)
  print("Dry Running project module!")
end

function M.help()
  print("This is a help")
end

return M
