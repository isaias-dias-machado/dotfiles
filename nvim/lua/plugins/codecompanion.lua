return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
  opts = {
    -- Cost governance: keep background cheap if you enable it
    interactions = {
      chat = {
        adapter = { name = "openai", model = "gpt-5.1-codex" },
      },
      inline = {
        adapter = { name = "openai", model = "gpt-5.1-codex-mini" },
      },
      background = { adapter = { name = "openai", model = "gpt-5.1-codex-mini" } },
    },

    -- Optional: enable debug while bringing this up
    opts = {
      log_level = "INFO",
    },
  },
}
