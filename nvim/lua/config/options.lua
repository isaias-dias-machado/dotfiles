-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- opts.rocks.enaled = false
require("config.filetypes")

vim.opt.path:append(vim.fn.stdpath("config") .. "/**")
vim.opt.sidescrolloff = 0
vim.opt.clipboard = ""
vim.opt.guicursor = ""
vim.opt.hidden = false
vim.opt.swapfile = false
vim.opt.list = false
vim.opt.wrap = true
vim.opt.listchars = {
  tab = "  ",
  space = "·",
  trail = "-",
  nbsp = "+",
}
