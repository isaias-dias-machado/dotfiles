return {
  "neovim/nvim-lspconfig",
  -- config = function()
  --   local lspconfig = require("lspconfig")
  --   local configs = require("lspconfig.configs")

  --   if not configs.ctags_lsp then
  --     configs.ctags_lsp = {
  --       default_config = {
  --         cmd = { "ctags-lsp" },
  --         filetypes = { "elixir" },
  --         root_dir = lspconfig.util.root_pattern("mix.exs", ".git"),
  --         settings = {},
  --       },
  --     }
  --   end

  --   lspconfig.ctags_lsp.setup({})
  -- end,
}
