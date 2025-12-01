return {
  -- единый Trouble
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { win = { position = "right", size = 50 } },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble quickfix diagnostics toggle focus=true position=right<cr>",
        desc = "Diagnostics (right)",
      },
      {
        "<leader>xb",
        "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true position=right<cr>",
        desc = "Buffer Diagnostics",
      },
      { "<leader>xq", "<cmd>Trouble qflist toggle focus=true position=right<cr>", desc = "Quickfix (right)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle focus=true position=right<cr>", desc = "Loclist (right)" },
      { "gR", "<cmd>Trouble lsp toggle focus=true position=right win.size=50<cr>", desc = "LSP References (right)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=true position=right<cr>", desc = "Document Symbols (right)" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- Go: можно оставить пусто, если используете golangci через go.nvim
        python = { "ruff" },
        json = { "jsonlint" },
        dockerfile = { "hadolint" },
        markdown = { "markdownlint-cli2" }, -- у вас стоит markdownlint-cli2
        sh = { "shellcheck" }, -- если установлен
      }
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2, -- небольшой отступ от кода
          source = "if_many", -- показывать источник, если их несколько
          prefix = "", -- без иконок/символов перед текстом
        },
        severity_sort = true,
        update_in_insert = false,
        float = { border = "rounded", source = "always" },
        signs = true,
        underline = true,
      })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
