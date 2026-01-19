return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "fallback" },
    },
    sources = {
      per_filetype = {
        codecompanion = { "codecompanion" },
      },
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
          min_keyword_length = 0,
          score_offset = 4,
        },
        path = {
          min_keyword_length = 2,
          score_offset = 1,
        },
        buffer = {
          min_keyword_length = 2,
          score_offset = -100,
        },
      },
    },
  },
}
