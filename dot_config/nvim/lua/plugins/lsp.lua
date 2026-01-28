return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "vtsls", "biome" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatBiome", { clear = true })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      local function on_attach(client, bufnr)
        if client.server_capabilities.codeActionProvider then
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
            buffer = bufnr,
            desc = "LSP: code action",
          })
        end

        if client.server_capabilities.renameProvider then
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {
            buffer = bufnr,
            desc = "LSP: rename",
          })
        end

        vim.keymap.set("n", "gl", vim.diagnostic.open_float, {
          buffer = bufnr,
          desc = "Diagnostics: open float",
        })

        if client.name == "vtsls" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        if client.name == "biome" then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(format_client)
                  return format_client.name == "biome"
                end,
              })
            end,
          })
        end
      end

      vim.lsp.config("vtsls", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
          javascript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
        },
      })
      vim.lsp.config("biome", { on_attach = on_attach, capabilities = capabilities })
      vim.lsp.enable({ "vtsls", "biome" })
    end,
  },
}
