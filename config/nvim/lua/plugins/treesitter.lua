return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- the rewritten, maintained branch (master is frozen)
    lazy = false,
    build = ':TSUpdate',
    opts = {
      parsers = { 'lua', 'vimdoc', 'bash', 'markdown', 'markdown_inline' },
    },
    config = function(_, opts)
      require('nvim-treesitter').install(opts.parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if vim.bo[args.buf].buftype ~= '' then return end
          pcall(vim.treesitter.start, args.buf) -- no-op if parser is not installed
        end,
        desc = 'Start treesitter highlighting when a parser is available',
      })
    end,
  },
}
