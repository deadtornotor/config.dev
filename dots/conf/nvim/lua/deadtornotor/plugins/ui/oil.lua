return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { "echasnovski/mini.icons" },
  lazy = false,
  config = function()
    CustomOilBar = function()
      local path = vim.fn.expand "%"
      path = path:gsub("oil://", "")

      return "  " .. vim.fn.fnamemodify(path, ":p:h")
    end

    require("oil").setup({
      columns = { "icon" },

      default_file_explorer = true,

      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
      win_options = {
        winbar = "%{v:lua.CustomOilBar()}",
      },
      view_options = {
        show_hidden = true,
      },
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end
}
