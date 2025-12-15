-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Jenkinsfile",
  callback = function()
    vim.bo.filetype = "groovy"
  end,
})

-- Helm filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/templates/*.yaml", "*/templates/*.tpl", "*/templates/*.yml" },
  callback = function()
    local path = vim.fn.expand("%:p")
    -- Check if we're in a Helm chart (Chart.yaml exists in parent directories)
    if vim.fn.findfile("Chart.yaml", path .. ";") ~= "" then
      vim.bo.filetype = "helm"
    end
  end,
})
