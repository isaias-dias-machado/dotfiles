-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- opts.rocks.enaled = false

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.wrap = false
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 20

vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.formatoptions:remove({ "t", "c" })

vim.g.mapleader = " "
vim.opt.hlsearch = false
vim.opt.syntax = "off"
vim.opt.background = "light"
vim.g.root_spec = { { ".git" }, "cwd" }
vim.opt.path:append(vim.fn.stdpath("config") .. "/**")
vim.opt.sidescrolloff = 0
vim.opt.spelllang = "pt_pt,en_gb"
vim.opt.clipboard = ""
vim.opt.guicursor = ""
vim.opt.hidden = false
vim.opt.swapfile = false
vim.opt.list = false
vim.opt.textwidth = 80
vim.opt.listchars = {
  tab = "  ",
  space = "·",
  trail = "-",
  nbsp = "+",
}

vim.keymap.set("n", "*", "*N", { desc = "Search work inplace" })

-- vim.keymap.set("n", "<Leader>/", ":grep '' | copen<Left><Left><Left><Left><Left><Left><Left><Left><Left>", { desc = "Grep and Open Quickfix" })
-- vim.keymap.set("n", "<Leader><Leader>", ":find *", { desc = "Find Directory" })

vim.keymap.set("n", "<Leader>fd", "<cmd>Dir<cr>", { desc = "Find Directory" })
vim.keymap.set("v", "<Leader>p", '"_dP', { desc = "Preserve yanked content on paste" })
vim.keymap.set("n", "-", '<cmd>Ex<cr>')

vim.opt.path:append("**") 
vim.opt.path:append("~/.config/nvim/lua/config/options.lua") 

local undodir = vim.fn.stdpath("cache") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.undofile = true
vim.opt.undodir = undodir

if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.api.nvim_create_user_command("Dir", function()
  local dirs = vim.fn.systemlist("find . -type d -not -path '*/.*'")
  vim.ui.select(dirs, {
    prompt = "Select directory:",
  }, function(choice)
    if choice then
      vim.cmd("edit " .. choice)
    end
  end)
end, {})

require("oil").setup({
    columns = { "icon" },
    view_options = {
        show_hidden = true,
    },
  skip_confirm_for_simple_edits = true,
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>")

-- TAGS

vim.o.tags = vim.o.tags .. ',' .. vim.fn.expand('~/.cache/ctags/stdlib.tags') .. ',tags'

local tags_cache = vim.fn.stdpath("cache") .. "/tags"
if vim.fn.isdirectory(tags_cache) == 0 then
    vim.fn.mkdir(tags_cache, "p")
end

vim.g.gutentags_project_root = { ".git", "Makefile", "src" }
vim.g.gutentags_ctags_tagfile = ".tags"
vim.g.gutentags_cache_dir = tags_cache
vim.g.gutentags_quiet = 1
vim.g.gutentags_ctags_exclude = { 
    "node_modules", 
    "build", 
    "_build", 
    ".git", 
    "bin", 
    "obj", 
    "*.json", 
    "*.md" 
}

-- require("conform").setup({
--   formatters_by_ft = {
--     c = { "clang-format" },
--     cpp = { "clang-format" },
--     elixir = { "mix" },
--   },
--   formatters = {
--     mix = {
--       command = "mix",
--       args = { "format", "-" },
--       stdin = true,
--     },
--   },
--   format_on_save = {
--     timeout_ms = 500,
--     lsp_fallback = false,
--   },
-- })


require('fzf-lua').setup({
  actions = {
    files = {
      ["enter"]       = FzfLua.actions.file_edit_or_qf,
      ["ctrl-s"]      = FzfLua.actions.file_split,
      ["ctrl-v"]      = FzfLua.actions.file_vsplit,
      ["ctrl-t"]      = FzfLua.actions.file_tabedit,
      ["alt-q"]       = FzfLua.actions.file_sel_to_qf,
      ["alt-Q"]       = FzfLua.actions.file_sel_to_ll,
      ["alt-i"]       = FzfLua.actions.toggle_ignore,
      ["alt-h"]       = FzfLua.actions.toggle_hidden,
      ["alt-f"]       = FzfLua.actions.toggle_follow,
      ["ctrl-j"] = function(selected)
        if not selected or #selected == 0 then return end
        
        local path, line = selected[1]:match("^(.-):(%d+):")
        
        if path and line then
          vim.cmd("pedit +normal\\ " .. line .. "Gzz " .. vim.fn.fnameescape(path))
        end
      end
    }
  }
})

vim.keymap.set('n', '<leader><leader>', FzfLua.files)
vim.keymap.set('n', '<leader>/', FzfLua.grep_project)

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Build and Debug --

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = [=[[^l]*]=],
    command = "cwindow",
})

vim.keymap.set('n', '<leader>m', ':silent make | redraw!<CR>')

local build_configs = {
    c = "make",
    elixir = "mix compile"
}

for ft, command in pairs(build_configs) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
            vim.opt_local.makeprg = command
        end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = (ft == "c") and { "*.c", "*.h" } or "*.ex,*.exs",
        callback = function()
            vim.cmd("silent make | redraw!")
        end,
    })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    callback = function()
        vim.bo.commentstring = "/* %s */"
    end
})

local dap = require('dap')

local cpptools_path = vim.fn.expand('~/.local/share/nvim/cpptools/extension/debugAdapters/bin/OpenDebugAD7')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = cpptools_path,
}

dap.configurations.c = {
  {
    name = "Launch a.out (ASan)",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. '/a.out'
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    -- Pass ASAN_OPTIONS as environment variables
    environment = {
      { name = "ASAN_OPTIONS", value = "detect_leaks=0:abort_on_error=1:halt_on_error=1" },
    },
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing',
        ignoreFailures = false
      },
      -- This ensures GDB catches the ASan crash immediately
      {
        text = 'handle SIGABRT stop nopass',
        description = 'stop on ASan abort',
        ignoreFailures = true
      },
    },
  },
}

vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end)

-- --
