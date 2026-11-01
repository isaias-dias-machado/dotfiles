return {
  -- File explorer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        view_options = {
          show_hidden = true,
          sort = {
            { "name", "asc" },
          },
        },
        skip_confirm_for_simple_edits = true,
      })
    end,
  },

  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        actions = {
          files = {
            ["enter"] = fzf.actions.file_edit_or_qf,
            ["ctrl-s"] = fzf.actions.file_split,
            ["ctrl-v"] = fzf.actions.file_vsplit,
            ["ctrl-t"] = fzf.actions.file_tabedit,
            ["alt-q"] = fzf.actions.file_sel_to_qf,
            ["alt-Q"] = fzf.actions.file_sel_to_ll,
            ["alt-i"] = fzf.actions.toggle_ignore,
            ["alt-h"] = fzf.actions.toggle_hidden,
            ["alt-f"] = fzf.actions.toggle_follow,
            ["ctrl-j"] = function(selected)
              if not selected or #selected == 0 then return end
              local path, line = selected[1]:match("^(.-):(%d+):")
              if path and line then
                vim.cmd("pedit +normal\\ " .. line .. "Gzz " .. vim.fn.fnameescape(path))
              end
            end,
          },
        },
      })
    end,
  },

  -- Tags
  { "ludovicchabant/vim-gutentags" },

  -- LSP
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_enable = true, -- auto-enable servers installed via Mason
      })
    end,
  },
}
