-- Generic LSP behavior. Language-specific servers live in lua/local.lua.

-- Neovim 0.11 already ships defaults: grn = rename, gra = code action,
-- grr = references, gri = implementation, gO = document symbols,
-- K = hover, <C-s> (insert) = signature help, ]d/[d = next/prev diagnostic.
-- Below adds the classic navigation the defaults leave out.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
    end
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('gD', vim.lsp.buf.declaration, 'Go to declaration')
  end,
})

vim.diagnostic.config({
  virtual_text = false, -- don't draw diagnostic text inline in the buffer
  signs = true,
  underline = true,
  severity_sort = true,
  jump = {
    float = true, -- ]d / [d open a floating popup instead of just moving the cursor
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    header = '',
    prefix = '',
  },
})
