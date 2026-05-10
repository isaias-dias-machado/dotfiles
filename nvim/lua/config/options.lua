-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- opts.rocks.enaled = false

vim.cmd("colorscheme darkblue")
-- vim.cmd("syntax off")
vim.g.loaded_matchparen = 1

vim.opt.fileencodings = { "utf-8", "latin1" }

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.wrap = false
vim.opt.sidescroll = 5
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

vim.keymap.set("n", "<leader><BS>", "I<CR><esc>")
vim.keymap.set("n", "<leader><CR>", "A<CR><esc>")
vim.keymap.set({"n", "v", "x"}, "<C-L>", "20zl")
vim.keymap.set({"n", "v", "x"}, "<C-H>", "20zh")

vim.keymap.set("n", "*", "*N", { desc = "Search work inplace" })

-- vim.keymap.set("n", "<Leader>/", ":grep '' | copen<Left><Left><Left><Left><Left><Left><Left><Left><Left>", { desc = "Grep and Open Quickfix" })
-- vim.keymap.set("n", "<Leader>/", ":grep '' | copen<Left><Left><Left><Left><Left><Left><Left><Left><Left>", { desc = "Grep and Open Quickfix" })
-- vim.keymap.set("n", "<Leader><Leader>", ":find *", { desc = "Find Directory" })
vim.keymap.set("n", "<Leader>,", ":ls<CR>:b ")

vim.keymap.set("n", "<Leader>s", 'viw"zy:%s/\\<<C-r>"\\>//g<Left><Left>', { silent = true })
vim.keymap.set("v", "<Leader>s", '"hy:%s/<C-r>"//g<Left><Left>', { silent = true })
vim.keymap.set("n", "<Leader>fd", "<cmd>Dir<cr>", { desc = "Find Directory" })
vim.keymap.set("v", "<Leader>p", '"_dP', { desc = "Preserve yanked content on paste" })
vim.keymap.set("n", "-", '<cmd>Ex<cr>')

vim.opt.path:append("**") 
vim.opt.path:append("~/.config/nvim/lua/config/options.lua") 
vim.opt.path:append("~/.config/nvim/ftplugin") 

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
        sort = {
          { "name", "asc" },
        },
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

-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--     pattern = [=[[^l]*]=],
--     command = "cwindow",
-- })

vim.opt.makeprg = "./_build.sh %"

local compile_filetypes = {
  elixir = true,
  erlang = true,
  rust = true,
  c = true,
  cpp = true,
  python = true,
  javascript = true,
  typescript = true,
}

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "*",
  command = "cwindow",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    if not compile_filetypes[vim.bo.filetype] then
      return
    end
    vim.cmd("silent make | redraw!")
  end,
})

vim.keymap.set('n', '<leader>m', ':silent make | redraw!')
vim.keymap.set("n", "<F5>", function()
  vim.cmd("split | terminal bash _run.sh")
end, { noremap = true, silent = true })

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
