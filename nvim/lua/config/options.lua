-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- opts.rocks.enaled = false
require("config.filetypes")

-- In your init.lua
vim.opt.tabstop = 4 -- Display tab characters as 4 spaces wide
vim.opt.shiftwidth = 2 -- Use 2 spaces for indentation (>>, <<, auto-indent)
vim.opt.expandtab = true -- Convert tabs to spaces when you press Tab
vim.opt.softtabstop = 2 -- Make Tab key insert 2 spaces

vim.opt.path:append(vim.fn.stdpath("config") .. "/**")
vim.opt.sidescrolloff = 0
vim.opt.spelllang = "pt_pt,en_gb"
vim.opt.clipboard = ""
vim.opt.guicursor = ""
vim.opt.hidden = false
vim.opt.swapfile = false
vim.opt.list = false
vim.opt.wrap = true
vim.opt.textwidth = 80
vim.opt.listchars = {
  tab = "  ",
  space = "·",
  trail = "-",
  nbsp = "+",
}
