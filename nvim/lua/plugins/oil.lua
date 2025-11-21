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
    keymaps = {
      ["!"] = {
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if not entry or not dir then
            return
          end

          -- Get the full path of the item under cursor
          local item_path = dir .. entry.name

          -- Pre-populate command line with ! and the path
          vim.api.nvim_feedkeys(
            ":"
              .. "! "
              .. vim.fn.fnameescape(item_path)
              .. vim.api.nvim_replace_termcodes("<Home>", true, false, true)
              .. vim.api.nvim_replace_termcodes("<Right>", true, false, true),
            "n",
            false
          )
        end,
        desc = "Prepopulate command line with ! and file path",
        mode = "n",
      },
      ["."] = {
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if not entry or not dir then
            return
          end

          -- Get the full path of the item under cursor
          local item_path = dir .. entry.name

          -- Pre-populate command line with : and the path
          vim.api.nvim_feedkeys(
            ": " .. vim.fn.fnameescape(item_path) .. vim.api.nvim_replace_termcodes("<Home>", true, false, true),
            "n",
            false
          )
        end,
        desc = "Prepopulate command line with file path",
        mode = "n",
      },
    },
  },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
}
