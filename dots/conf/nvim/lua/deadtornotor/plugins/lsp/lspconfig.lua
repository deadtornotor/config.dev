return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "folke/lazydev.nvim",
    },
    config = function()
      local servers = require("deadtornotor.conf.languages").servers

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        require("lspconfig")[server].setup(opts)
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end
            })
          end
        end,
      })
    end,
    keys = {
      { "<leader>fb", function() vim.lsp.buf.format() end, "n", desc = "Format current buffer" },
    },
  }
}
