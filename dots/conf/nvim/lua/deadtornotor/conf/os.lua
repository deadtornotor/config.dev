-- File: lua/conf/os.lua
local M = {}

-- OS-specific executable paths
M.linux = {
  node = "/usr/bin/node",      -- path to node executable
  python = "/usr/bin/python3", -- path to python executable
  lldb = "lldb",               -- codelldb (installed by mason)
}

M.windows = {
  node = "C:\\Program Files\\nodejs\\node.exe", -- path to node executable
  python = "C:\\Python39\\python.exe",          -- path to python executable
  lldb = "lldb",                                -- codelldb (installed by mason)
}

-- This determines the current OS and returns the appropriate paths
M.current = (vim.loop.os_uname().sysname:find 'Windows' and true or false) and M.windows or M.linux

return M
