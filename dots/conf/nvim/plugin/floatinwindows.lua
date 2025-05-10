vim.keymap.set("t", "<esc><esc>", "<C-\\><C-N>")


---@class DeadyWinState
---@field buf number
---@field win number

---@class DeadyWinOpts
---@field state? DeadyWinState
---@field height? number
---@field width? number
---@field on_open? fun(bufnr: number, winnr: number)


local state = {
  floating_term = {
    buf = -1,
    win = -1,
  }
}

---Create a floating window
---@param opts DeadyWinOpts
---@return DeadyWinState
local function create_floating_window(opts)
  opts = opts or { state = { buf = -1, win = -1 } }

  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  if opts.state.buf == -1 or not vim.api.nvim_buf_is_valid(opts.state.buf) then
    opts.state.buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  if opts.state.win == -1 or not vim.api.nvim_win_is_valid(opts.state.win) then
    opts.state.win = vim.api.nvim_open_win(opts.state.buf, true, win_config)
    if opts.on_open then
      opts.on_open(opts.state.buf, opts.state.win)
    end
  end

  return opts.state
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating_term.win) then
    state.floating_term = create_floating_window({
      state = state.floating_term,
    })

    if vim.bo[state.floating_term.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating_term.win)
  end
end

vim.api.nvim_create_user_command("FloatinTerm", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "Opens a floating terminal" })
