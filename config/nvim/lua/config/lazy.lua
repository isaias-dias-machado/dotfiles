-- lazy.nvim bootstrap and setup.

local M = {}

--- Bootstrap lazy.nvim and load base + machine-local plugin specs.
--- @param local_plugins table[] extra specs from lua/local.lua
function M.setup(local_plugins)
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local ok = pcall(vim.fn.system, {
      'git', 'clone', '--filter=blob:none', '--branch=stable',
      'https://github.com/folke/lazy.nvim.git', lazypath,
    })
    if not ok or vim.v.shell_error ~= 0 then
      vim.notify('Failed to clone lazy.nvim. Check git and network access.', vim.log.levels.ERROR)
      return
    end
  end
  vim.opt.rtp:prepend(lazypath)

  local specs = { { import = 'plugins' } }
  vim.list_extend(specs, local_plugins or {})

  require('lazy').setup(specs, {
    -- Keep the lockfile next to this config so plugin versions only change
    -- when *you* run :Lazy update.
    lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json',
    ui = { border = 'single' },
    -- No plugin here uses luarocks/rockspecs; disabling this silences the
    -- checkhealth "hererocks/luarocks not installed" error.
    rocks = { enabled = false },
    -- lazy.nvim resets runtimepath; keep the site dir, where nvim-treesitter
    -- (main branch) installs parsers and queries.
    performance = {
      rtp = {
        paths = { vim.fn.stdpath('data') .. '/site' },
      },
    },
  })
end

return M
