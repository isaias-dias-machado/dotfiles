return {
  {
    "ludovicchabant/vim-gutentags",
    config = function()
      vim.g.gutentags_ctags_executable = "ctags"
      -- Store tags in a central location or project root
      vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/ctags"
      -- Ensure the cache directory exists
      if vim.fn.isdirectory(vim.g.gutentags_cache_dir) == 0 then
        vim.fn.mkdir(vim.g.gutentags_cache_dir, "p")
      end
    end,
  },
}
