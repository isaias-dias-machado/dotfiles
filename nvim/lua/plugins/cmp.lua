return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "fallback" },
    },
    sources = {
      default = { "snippets", "lsp", "path", "buffer" },
      providers = {
        snippets = {
          min_keyword_length = 2,
          score_offset = 2,
          opts = {
            friendly_snippets = true,
            extended_filetypes = {
              elixir = { "html", "heex", "ex" },
            },
          },
        },
        lsp = {
          min_keyword_length = 3,
          score_offset = 4,
        },
        path = {
          min_keyword_length = 3,
          score_offset = 1,
        },
        buffer = {
          min_keyword_length = 5,
          score_offset = -100,
        },
      },
    },
  },
}
