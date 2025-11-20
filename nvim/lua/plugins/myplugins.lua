return {
  { "sainnhe/gruvbox-material" },
  { "mbbill/undotree" },
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "tpope/vim-rsi" },
  { "elixir-editors/vim-elixir" },
  { "honza/vim-snippets" },
  { "andrewstuart/vim-kubernetes" },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_ultisnips").lazy_load()
    end,
    { "avdgaag/vim-phoenix" },
  },
}
