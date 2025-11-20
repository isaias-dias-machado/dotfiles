return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = false,
  },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
}
