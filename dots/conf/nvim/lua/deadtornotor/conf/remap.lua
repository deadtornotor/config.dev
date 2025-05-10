local function map(mode, lhs, rhs, desc, opts)
  desc = desc or rhs
  opts = opts or {}
  opts.desc = desc

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Stop p/P and d from overwriting clipboard
map("n", "d", '"_d')
map("v", "d", '"_d')
map("n", "p", '"0p')
map("n", "P", '"0P')

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv'", "Move line up")

map("v", "K", ":m '>-2<CR>gv=gv'", "Move line down")

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- Move windows
map('n', '<C-h>', '<C-w><C-h>', 'Move focus to the left window')
map('n', '<C-l>', '<C-w><C-l>', 'Move focus to the right window')
map('n', '<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
map('n', '<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

map("n", "<F1>", ':tabprevious<CR>', "Move to previous tab")
map("n", "<F2>", ':tabnext<CR>', "Move to next tab")


map("n", '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
map({ "n", "x" }, '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map("n", 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

vim.keymap.set("n", "<leader>cd", function()
  local using_oil, oil = pcall(require, "oil")
  local path

  if using_oil and oil.get_current_dir() then
    -- Inside an Oil buffer
    path = oil.get_current_dir()
  else
    -- Regular file buffer
    path = vim.fn.expand("%:p:h")
  end

  -- Change the working directory
  vim.cmd("cd " .. vim.fn.fnameescape(path))
  print("Changed directory to: " .. path)
end, { desc = "Change working directory to current file's directory" })



vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('deadtornotor-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
