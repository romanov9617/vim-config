return {
  -- 1. LSP для Python (через nvim-lspconfig)
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup {}
      -- require("lspconfig").pylsp.setup{} -- альтернатива
      require "configs.lspconfig"
    end,
  },

  { "onsails/lspkind-nvim" },

  {
    "danymat/neogen",
    config = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "python" },
    keys = {
      {
        "<leader>gs",
        function()
          require("neogen").generate()
        end,
        desc = "Generate docstring",
      },
    },
  },
  -- 2. Автодополнение
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },

    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"
      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
        formatting = {
          format = lspkind.cmp_format { mode = "symbol_text", maxwidth = 50 },
        },
      }
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- 3. Treesitter (если ещё не включён)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "go",
        "lua",
        "vim",
        "bash",
        "html",
        "css",
        "json",
        "sql",
        "rust",
      },
      highlight = { enable = true },
    },
  },

  -- 4. Форматтеры (conform.nvim)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        go = { "gofmt", "goimports" }, -- если нужно
        rust = { "rustfmt", lsp_format = "fallback" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  -- 5. Поддержка виртуальных окружений (опционально, но удобно)
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   opts = {},
  --   event = "VeryLazy",
  --   dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
  -- },

  -- 6. Тесты (neotest)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
            runner = "pytest",
          },
        },
      }
    end,
  },

  -- 7. DAP (отладка, опционально)
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      require("dap-python").setup "python"
    end,
    ft = { "python" },
  },

  -- 8. Telescope — для удобного поиска по проекту
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- 9. which-key — подсказки по хоткеям
  { "folke/which-key.nvim", event = "VeryLazy" },

  -- 10. wakatime (твоя привычка!)
  { "wakatime/vim-wakatime", lazy = false },

  -- 11. Go support (оставляем твой вариант, если нужно)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp_cfg = {
        settings = {
          gopls = {
            usePlaceholders = false,
          },
        },
      },
      lsp_inlay_hints = {
        enable = false, -- this is the only field apply to neovim > 0.10
      },
    },
    config = function(lp, opts)
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "xemptuous/sqlua.nvim",
    lazy = true,
    cmd = "SQLua",
    config = function()
      require("sqlua").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite" },
    keys = {
      { "<leader>gs", ":Git status<CR>", desc = "Git Status (fugitive)" },
      { "<leader>gd", ":Gdiffsplit<CR>", desc = "Git Diffsplit" },
    },
  },
}
