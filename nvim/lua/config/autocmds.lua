-- Directory finder command
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

-- Transparent background (disabled for testing float issues)
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Open quickfix window after quickfix commands
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "*",
  command = "cwindow",
})

-- LSP: Disable diagnostics globally
vim.diagnostic.enable(false)

-- LSP: Suppress info messages (only show errors and warnings)
vim.lsp.handlers["window/showMessage"] = function(_, result, _)
  if result.type > 2 then return end
  vim.notify(result.message, result.type)
end

-- LSP: Minimal setup on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf

    -- Enable omnicompletion (Ctrl+x Ctrl+o)
    vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- K for hover docs (already default in Neovim 0.10+)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf })

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf })
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = buf })
  end,
})

-- Auto-compile on save for certain filetypes
local compile_filetypes = {
  css = true,
  html = true,
  elixir = true,
  erlang = true,
  rust = true,
  c = true,
  cpp = true,
  python = true,
  javascript = true,
  typescript = true,
}

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    if not compile_filetypes[vim.bo.filetype] then
      return
    end
    vim.cmd("silent make | redraw!")
  end,
})
