-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "

-- Disable matchparen
vim.g.loaded_matchparen = 1

-- Markdown folding
vim.g.markdown_folding = 1

-- File encoding
vim.opt.fileencodings = { "utf-8", "latin1" }

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Wrapping and scrolling
vim.opt.wrap = false
vim.opt.sidescroll = 5
vim.opt.sidescrolloff = 0
vim.opt.wrapmargin = 0
vim.opt.formatoptions:remove({ "t", "c" })

-- Search
vim.opt.hlsearch = false

-- Appearance
vim.opt.syntax = "off"
vim.opt.background = "light"
vim.opt.guicursor = ""
vim.opt.list = false
vim.opt.listchars = {
  tab = "  ",
  space = "·",
  trail = "-",
  nbsp = "+",
}

-- Behavior
vim.opt.hidden = false
vim.opt.swapfile = false
vim.opt.clipboard = ""

-- Spell
vim.opt.spelllang = "pt_pt,en_gb"

-- Path
vim.opt.path:append("**")
vim.opt.path:append(vim.fn.stdpath("config") .. "/**")
vim.opt.path:append("~/.config/nvim/lua/config/options.lua")
vim.opt.path:append("~/.config/nvim/ftplugin")

-- Undo
local undodir = vim.fn.stdpath("cache") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undofile = true
vim.opt.undodir = undodir

-- Grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Make
vim.opt.makeprg = "./_build.sh %"

-- Tags (gutentags settings - must be set before plugin loads)
vim.o.tags = vim.o.tags .. "," .. vim.fn.expand("~/.cache/ctags/stdlib.tags") .. ",tags"

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
  "*.md",
}

-- OCaml indent
vim.cmd('set rtp^="/home/isaias/.opam/default/share/ocp-indent/vim')
