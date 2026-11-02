return {
  {
    'saghen/blink.cmp',
    version = '1.*', -- pin to v1: prebuilt fuzzy binary, no v2 churn
    event = 'InsertEnter',
    opts = {
      -- 'default' preset: <C-y> accept, <C-n>/<C-p> or Up/Down select,
      -- <C-space> open menu / toggle docs, <C-e> cancel.
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = {
          function()
            local source_win = vim.api.nvim_get_current_win()

            -- Calling hover again focuses an existing hover window.
            vim.lsp.buf.hover()

            vim.schedule(function()
              if vim.api.nvim_get_current_win() ~= source_win then
                vim.cmd('stopinsert')
              end
            end)

            return true
          end,
        },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
      },
      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
      },
      fuzzy = { implementation = 'lua' },
      -- On nvim 0.11+ blink merges its LSP capabilities into vim.lsp.config
      -- automatically — no get_lsp_capabilities() wiring needed.
    },
  },
}
