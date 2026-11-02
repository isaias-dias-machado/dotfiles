-- Keymaps shared by every machine.

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

require('swap_params')

-- Paste without losing yanked content
vim.keymap.set('v', '<Leader>p', '"_dP', { desc = 'Preserve yanked content on paste' })

-- Oil file explorer
vim.keymap.set('n', '-', '<CMD>Oil<CR>')

-- Horizontal scrolling
vim.keymap.set({ 'n', 'v', 'x' }, '<C-L>', '20zl')
vim.keymap.set({ 'n', 'v', 'x' }, '<C-H>', '20zh')

-- Search and replace
vim.keymap.set('n', '*', '*N')
vim.keymap.set('n', '<Leader>s', 'viw"zy:%s/\\<<C-r>"\\>//g<Left><Left>', { silent = true })
vim.keymap.set('v', '<Leader>s', '"hy:%s/<C-r>"//g<Left><Left>', { silent = true })

-- Buffers
vim.keymap.set('n', '<Leader>,', ':ls<CR>:b ')
