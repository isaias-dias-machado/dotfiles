return {
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.surround').setup()
      require('mini.ai').setup()
      require('mini.pairs').setup()
      -- require('mini.completion').setup()
      -- require('mini.snippets').setup()
      -- add other mini modules here too, e.g.:
      -- require('mini.statusline').setup()
    end,
  },
}
