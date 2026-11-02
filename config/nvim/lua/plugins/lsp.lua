-- LSP plumbing: mason installs servers, lspconfig defines them, and
-- mason-lspconfig auto-enables whatever is installed.
-- Server lists and language-specific settings live in lua/local.lua.
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      { 'mason-org/mason-lspconfig.nvim', opts = {} },
    },
    config = false, -- no setup() function; config is in lua/config/lsp.lua
  },
}
