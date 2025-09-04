return {
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
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      require("dap-python").setup("python")
    end,
    ft = { "python" },
  },
  -- venv-selector (опционально)
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   opts = {},
  --   event = "VeryLazy",
  --   dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
  -- },
}
