vim.schedule(function()
  vim.opt.clipboard = "unnamedplus" -- This enables the system clipboard integration
  vim.g.clipboard = {
    name = "wl-copy",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste --no-newline",
      ["*"] = "wl-paste --no-newline",
    },
  }
end)

-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'

--vim.opt.clipboard = "unnamedplus"

-- Save undo file
vim.opt.undofile = true

vim.g.have_nerd_font = true

-- Enable break indent
vim.opt.breakindent = true


-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Keep signcolumn on default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Display which-key popup sooner
vim.opt.timeoutlen = 300

-- Splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- keep lines above and below
vim.opt.scrolloff = 10

vim.opt.hlsearch = true

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
