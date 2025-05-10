local M = {}

M.languages = {
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "javascript",
  "html",
  "cpp",
  "cmake",
  "python",
  "css",
  "go",
  "java",
  "json",
  "make",
  "sql",
}

M.servers = {
  "clangd",
  "lua_ls",
  "vimls",
  "html",
  "cmake",
  "pyright",
  "cssls",
  "gopls",
  "jdtls",
  "jsonls",
  "sqls",
  "lemminx",
}

M.debuggers = {
  "codelldb",
  "python",
  "debugpy",
  "java-debug-adapter",
}

return M
