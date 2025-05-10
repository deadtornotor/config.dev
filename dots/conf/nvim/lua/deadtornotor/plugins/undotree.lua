return {
  {
    "mbbill/undotree",
    config = function()
    end,
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, "n", desc = "Toggle undo tree" },
    }
  }
}
