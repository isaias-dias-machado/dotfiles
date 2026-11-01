-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load options before plugins
require("config.options")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})

-- Load keymaps and autocmds after plugins
require("config.keymaps")
require("config.autocmds")
require("config.swap_params")
