return {
  {
    'navarasu/onedark.nvim',
    lazy = false,    -- load at startup, not on a command/event
    priority = 1000, -- load before other plugins that might set highlights
    config = function()
      require('onedark').setup({}) -- dark, darker, cool, deep, warm, warmer, light
      require('onedark').load()
    end,
  },
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        columns = { 'icon' },
        view_options = {
          show_hidden = true,
          sort = {
            { 'name', 'asc' },
          },
        },
        skip_confirm_for_simple_edits = true,
      })
    end,
  },
}
