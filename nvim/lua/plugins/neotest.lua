return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      {
        "fredrikaverpil/neotest-golang",
        version = "*", -- Optional, but recommended
        build = function()
          vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
        end,
      },
      {
        "antoinemadec/FixCursorHold.nvim", -- помогает при зависаниях CursorHold
      },
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        log_level = 3,
        consumers = {},
        icons = {
          passed = "✅",
          failed = "❌",
          running = "🏃",
          skipped = "⚠️",
          unknown = "❓",
          non_collapsible = "─",
          collapsed = "▶️",
          expanded = "🔽",
        },
        highlights = {
          passed = "NeotestPassed",
          failed = "NeotestFailed",
          running = "NeotestRunning",
          skipped = "NeotestSkipped",
          unknown = "NeotestUnknown",
        },
        floating = {
          max_height = 0.9,
          max_width = 0.9,
          border = "rounded",
          options = {},
        },
        strategies = {
          integrated = {
            width = 140,
            height = 30,
          },
        },
        run = { enabled = true },
        summary = {
          enabled = true,
          follow = true,
          animated = true,
          expand_errors = true,
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        output_panel = {
          enabled = true,
          open = "botright 15split",
        },
        quickfix = { enabled = false, open = false },
        status = { enabled = true, virtual_text = true, signs = true },
        state = { enabled = true },
        watch = { enabled = false },
        diagnostic = { enabled = true, severity = 1 },
        projects = {},
        discovery = { enabled = true },
        running = { concurrent = true },
        default_strategy = "integrated",

        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
          require("neotest-golang")({
            runner = "gotestsum",
          }),
        },
      })

      -- 🔧 Удобные маппинги
      local map = vim.keymap.set
      map("n", "<leader>tt", function()
        neotest.run.run()
      end, { desc = "Run nearest test 🧪" })
      map("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run file tests 📄" })
      map("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle summary 🗂️" })
      map("n", "<leader>to", function()
        neotest.output.open({ enter = true })
      end, { desc = "Open output 🔍" })
      map("n", "<leader>tp", function()
        neotest.output_panel.toggle()
      end, { desc = "Toggle output panel 📊" })
      map("n", "<leader>tl", function()
        neotest.run.run_last()
      end, { desc = "Run last test 🔁" })
      map("n", "<leader>td", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "Debug nearest test 🐞" })
    end,
  },
}
