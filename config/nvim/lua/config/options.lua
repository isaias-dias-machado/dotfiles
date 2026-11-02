-- Editor options shared by every machine.

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Wrapping and scrolling
vim.opt.wrap = false
vim.opt.textwidth = 0
vim.opt.sidescroll = 5
vim.opt.sidescrolloff = 0
vim.opt.wrapmargin = 0
vim.opt.formatoptions:remove({ 't', 'c' })

vim.opt.foldlevelstart = 99

-- Search
vim.opt.hlsearch = false

-- Appearance
vim.opt.guicursor = ''
vim.opt.list = false
vim.opt.listchars = {
  tab = '  ',
  space = '·',
  trail = '-',
  nbsp = '+',
}

-- Behavior
vim.opt.hidden = false
vim.opt.swapfile = false
vim.opt.clipboard = ''

-- Spell
vim.opt.spelllang = 'pt_pt,en_gb'

-- Path
vim.opt.path:append(vim.fn.stdpath('config'))
vim.opt.path:append('**')

vim.o.signcolumn = 'yes' -- no layout shift when diagnostics appear
vim.o.undofile = true    -- persistent undo
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 300
