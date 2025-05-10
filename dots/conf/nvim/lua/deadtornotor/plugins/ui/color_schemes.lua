return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        light_style = "storm",
        dim_inactive = true,
      })

      vim.cmd.colorscheme "tokyonight"
    end,
  }
}
