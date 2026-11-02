return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<leader><leader>', function() require('telescope.builtin').find_files() end,                    desc = 'Find files' },
      { '<leader>/',        function() require('telescope.builtin').live_grep() end,                     desc = 'Live grep' },
      -- LSP pickers (optional but handy; delete if you prefer the quickfix list)
      { 'f12',              function() require('telescope.builtin').lsp_references() end,                desc = 'LSP references' },
      { 'f11',              function() require('telescope.builtin').lsp_implementations() end,           desc = 'LSP implementations' },
      { '<leader>o',        function() require('telescope.builtin').lsp_document_symbols() end,          desc = 'Symbols: file' },
      { '<leader>t',        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = 'Symbols: workspace' },
    },
    config = function()
      if vim.fn.executable('rg') == 0 then
        vim.notify('ripgrep (rg) not found: Telescope live_grep will not work', vim.log.levels.WARN)
      end
    end,
  },
}
