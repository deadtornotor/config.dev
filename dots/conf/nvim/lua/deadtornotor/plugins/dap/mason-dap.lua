return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  }
}
