return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    keys = {
      { "<F3>",      function() require("dap").continue() end,          desc = "Run/Continue" },
      { "<F5>",      function() require("dap").step_into() end,         desc = "Step into" },
      { "<F6>",      function() require("dap").step_over() end,         desc = "Step over" },
      { "<F7>",      function() require("dap").step_out() end,          desc = "Step out" },
      { "<F8>",      function() require("dap").step_back() end,         desc = "Step back" },
      { "<F9>",      function() require("dap").restart() end,           desc = "Restart" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle [b]reackpoint" },
    },

    config = function()
      local dap = require("dap")

      -- Set up debuggers
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.adapters.codelldb = {
        type = "server",
        port = "localhost",
        executable = {
          command = "codelldb",
          args = { "--port", "localhost" },
        },
      }

      dap.adapters.java = {
        type = "server",
        host = "localhost",
        port = 5005,
      }

      -- Python configuration
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch Python File",
          program = "${file}",
        },
      }

      -- C++ configuration
      dap.configurations.cpp = {
        {
          name = "Launch C++ File",
          type = "codelldb",
          request = "launch",
          program = "${fileDirname}/${fileBasenameNoExtension}",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Java configuration
      dap.configurations.java = {
        {
          name = "Launch Java File",
          type = "java",
          request = "launch",
          mainClass = "${file}",
          projectName = "${workspaceFolderBasename}",
        },
      }
    end,
  }
}
