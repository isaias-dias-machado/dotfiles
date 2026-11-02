-- Portable Neovim config entry point.
-- Requires: Neovim 0.11+, git, a C compiler (treesitter), ripgrep (live_grep).
-- Machine-specific settings live in lua/local.lua (gitignored).

if vim.fn.has('nvim-0.11') == 0 then
  vim.notify('This config requires Neovim 0.11+', vim.log.levels.ERROR)
  return
end

-- Leader must be set before any <Leader> mapping is defined.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.lsp')

-- lua/local.lua is optional and machine-specific. It returns:
--   { plugins = { ... }, setup = function() ... end }
-- Top-level code runs before lazy.setup; setup() runs after it.
local local_config = { plugins = {}, setup = nil }
local local_path = vim.fn.stdpath('config') .. '/lua/local.lua'
if vim.fn.filereadable(local_path) == 1 then
  local ok, result = pcall(dofile, local_path)
  if ok and type(result) == 'table' then
    local_config = result
  elseif not ok then
    vim.notify('local.lua: ' .. tostring(result), vim.log.levels.ERROR)
  end
end

require('config.lazy').setup(local_config.plugins or {})

if type(local_config.setup) == 'function' then
  local ok, err = pcall(local_config.setup)
  if not ok then
    vim.notify('local.lua setup: ' .. tostring(err), vim.log.levels.ERROR)
  end
end
