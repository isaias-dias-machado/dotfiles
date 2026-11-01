-- ============================================================================
-- Minimal init.lua — BEAM (Erlang/ELP, Elixir, Gleam) + Bash + C + Rust
-- Requires: Neovim 0.11+, git, a C compiler (treesitter), ripgrep (live_grep)
-- Plugins: lazy.nvim, mason, mason-lspconfig, nvim-lspconfig,
--          blink.cmp, otter.nvim, telescope, nvim-treesitter.
-- ============================================================================

-- ---------------------------------------------------------------- options --
-- Leader must be set before any <Leader> mapping is defined.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

require('swap_params')
-- Mappings
-- Paste without losing yanked content
vim.keymap.set("v", "<Leader>p", '"_dP', { desc = "Preserve yanked content on paste" })
-- Oil file explorer
vim.keymap.set("n", "-", "<CMD>Oil<CR>")
-- Horizontal scrolling
vim.keymap.set({ "n", "v", "x" }, "<C-L>", "20zl")
vim.keymap.set({ "n", "v", "x" }, "<C-H>", "20zh")
-- Search and replace
vim.keymap.set("n", "*", '*N')
vim.keymap.set("n", "<Leader>s", 'viw"zy:%s/\\<<C-r>"\\>//g<Left><Left>', { silent = true })
vim.keymap.set("v", "<Leader>s", '"hy:%s/<C-r>"//g<Left><Left>', { silent = true })
-- Buffers
vim.keymap.set("n", "<Leader>,", ":ls<CR>:b ")

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
vim.opt.formatoptions:remove({ "t", "c" })

-- markdown folding
vim.g.markdown_folding = 1
vim.opt.foldlevelstart = 99

-- Search
vim.opt.hlsearch = false

-- Appearance
-- vim.opt.syntax = "off"
vim.opt.guicursor = ""
vim.opt.list = false
vim.opt.listchars = {
  tab = "  ",
  space = "·",
  trail = "-",
  nbsp = "+",
}

-- Behavior
vim.opt.hidden = false
vim.opt.swapfile = false
vim.opt.clipboard = ""

-- Spell
vim.opt.spelllang = "pt_pt,en_gb"

-- Path
vim.opt.path:append("/home/isaias/.config/nvim")
vim.opt.path:append("**")

vim.o.signcolumn = 'yes' -- no layout shift when diagnostics appear
vim.o.undofile = true    -- persistent undo
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 300

vim.filetype.add({
  pattern = {
    ['.*/*.als'] = 'alloy',
  },
})
-- ---------------------------------------------------- bootstrap lazy.nvim --
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------- plugins --
require('lazy').setup({
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "vincentlu/alloy.nvim" },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    opts = {
      defaul_mappings = true
    }
  },
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.surround').setup()
      require('mini.ai').setup()
      require('mini.pairs').setup()
      -- require('mini.completion').setup()
      -- require('mini.snippets').setup()
      -- add other mini modules here too, e.g.:
      -- require('mini.statusline').setup()
    end,
  },
  {
    'jmbuhr/otter.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'neovim/nvim-lspconfig',
    },
    opts = {
      buffers = {
        -- LSP setup is triggered by the filetype of Otter's hidden buffers.
        set_filetype = true,
        write_to_disk = false,
      },
    },
    config = function(_, opts)
      local otter = require('otter')
      otter.setup(opts)

      local function activate_markdown_languages()
        otter.activate({ 'python', 'latex' }, true, true)
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = activate_markdown_languages,
        desc = 'Enable Python and LaTeX tooling in Markdown code fences',
      })
    end
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      anti_conceal = {
        enabled = false
      },
      win_options = {
        conceallevel = {
          default = 0,
          rendered = 3,
        },
        concealcursor = {
          default = '',
          rendered = 'n',
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        erlang = { "erlfmt" },
      },
      formatters = {
        erlfmt = {
          command = "erlfmt",
          args = { "-" },
          stdin = true,
        },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        view_options = {
          show_hidden = true,
          sort = {
            { "name", "asc" },
          },
        },
        skip_confirm_for_simple_edits = true,
      })
    end,
  },
  {
    'navarasu/onedark.nvim',
    lazy = false,                  -- load at startup, not on a command/event
    priority = 1000,               -- load before other plugins that might set highlights
    config = function()
      require('onedark').setup({}) -- dark, darker, cool, deep, warm, warmer, light
      require('onedark').load()
    end,
  },
  -- ==== LSP: mason installs servers, lspconfig defines them, ============
  -- ==== mason-lspconfig auto-enables whatever is installed. =============
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      vim.lsp.config('texlab', {
        -- "latex" is the filetype used by Otter's hidden LaTeX buffer.
        filetypes = { 'tex', 'plaintex', 'bib', 'latex' },
        settings = {
          texlab = {
            build = { onSave = false },
            chktex = {
              onOpenAndSave = false,
              onEdit = false,
            },
          },
        },
      })

      require('mason-lspconfig').setup({
        -- lspconfig names; mason maps them to its package names.
        ensure_installed = {
          'elp',           -- Erlang (erlang-language-platform)
          'elixirls',      -- Elixir (elixir-ls)
          'bashls',        -- Bash (bash-language-server)
          'clangd',        -- C
          'rust_analyzer', -- Rust
          'pyright',       -- Python, including Markdown code fences via Otter
          'texlab',        -- LaTeX, including Markdown code fences via Otter
        },
        -- automatic_enable = true (default): installed servers are started
        -- via vim.lsp.enable(), no per-server boilerplate needed.
      })

      -- shellcheck is not an LSP server, so it's not in ensure_installed.
      -- bashls shells out to it automatically when it's on PATH, and mason's
      -- bin dir is on Neovim's PATH — so just make sure it's installed.
      local registry = require('mason-registry')
      registry.refresh(function()
        local ok, pkg = pcall(registry.get_package, 'shellcheck')
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end)

      -- Gleam's LSP ships inside the `gleam` binary itself (not via mason).
      -- Install gleam yourself; this just tells Neovim to attach it.
      vim.lsp.enable('gleam')
      vim.lsp.config('alloy_ls', {
        cmd = { '/home/isaias/.local/bin/myalloy', 'lsp' },
      })
      vim.lsp.enable('alloy_ls')
    end,
  },

  -- ==== Completion =======================================================
  {
    'saghen/blink.cmp',
    version = '1.*', -- pin to v1: prebuilt fuzzy binary, no v2 churn
    event = 'InsertEnter',
    opts = {
      -- 'default' preset: <C-y> accept, <C-n>/<C-p> or Up/Down select,
      -- <C-space> open menu / toggle docs, <C-e> cancel.
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = {
          function()
            local source_win = vim.api.nvim_get_current_win()

            -- Calling hover again focuses an existing hover window.
            vim.lsp.buf.hover()

            vim.schedule(function()
              if vim.api.nvim_get_current_win() ~= source_win then
                vim.cmd('stopinsert')
              end
            end)

            return true
          end,
        },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
      },
      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
        per_filetype = {
          markdown = { "lsp", "path", "snippets", "buffer" },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      -- On nvim 0.11+ blink merges its LSP capabilities into vim.lsp.config
      -- automatically — no get_lsp_capabilities() wiring needed.
    },
  },

  -- ==== Fuzzy finding ====================================================
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<leader><leader>', function() require('telescope.builtin').find_files() end,                    desc = 'Find files' },
      { '<leader>/',        function() require('telescope.builtin').live_grep() end,                     desc = 'Live grep' },
      -- LSP pickers (optional but handy; delete if you prefer the quickfix list)
      { 'f12',              function() require('telescope.builtin').lsp_references() end,                desc = 'LSP references' },
      { 'f11',              function() require('telescope.builtin').lsp_implementations() end,           desc = 'LSP implementations' },
      { '<leader>o',        function() require('telescope.builtin').lsp_document_symbols() end,          desc = 'Symbols: file' },
      { '<leader>t',        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = 'Symbols: workspace' },
    },
  },

  -- ==== Treesitter (better highlighting/indent; not cosmetic fluff) =====
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- the rewritten, maintained branch (master is frozen)
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({
        'erlang', 'elixir', 'heex', 'gleam',
        'bash', 'c', 'rust', 'lua', 'vimdoc',
        'markdown', 'markdown_inline', 'python', 'latex',
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'erlang', 'elixir', 'heex', 'gleam',
          'sh', 'bash', 'c', 'rust', 'lua', 'markdown',
        },
        callback = function()
          pcall(vim.treesitter.start) -- no-op if parser not installed yet
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").alloy = {
            tier = 3,
            install_info = {
              url = "https://github.com/vincentlu/tree-sitter-alloy",
              revision = "7bcc865b0d12ff4f20876efd072fd1bc11faff48",
              -- If the repository has no src/parser.c:
              generate = true,
            },
          }
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alloy",
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}, {
  -- lazy.nvim options: keep the lockfile next to this file so plugin
  -- versions only change when *you* run :Lazy update.
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

-- ------------------------------------------------------------ lsp keymaps --
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
    style = "minimal",
    border = "rounded",
    header = "",
    prefix = "",
  },
})

-- sytax highlighting for tlaplus
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tla",
  callback = function()
    vim.treesitter.start()
  end,
})

vim.g.tlaplus_mappings_enable = true

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = true,
      format = { enable = true },

      -- Built-in catalog support; no extra plugin required.
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },

      schemas = {
        kubernetes = {
          "**/*.k8s.yaml",
          "**/*.k8s.yml",
        },

        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "**/compose.yaml",
          "**/compose.yml",
          "**/compose.*.yaml",
          "**/compose.*.yml",
          "**/docker-compose*.yaml",
          "**/docker-compose*.yml",
        },
      },
    },
  },
})
vim.lsp.enable("yamlls")
