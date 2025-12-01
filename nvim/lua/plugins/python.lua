-- lua/plugins/python.lua
return {
  -- LSP: Pyright с корректным venv и адекватной строгостью
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "standard", -- можно "strict", если готовы к шуму
                autoImportCompletions = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
          --- Автоопределение Python из текущего venv (.venv, poetry, pipenv, uv)
          before_init = function(_, conf)
            local util = require("lspconfig.util")
            local root = util.root_pattern("pyproject.toml", "poetry.lock", "requirements.txt", ".git")(vim.fn.getcwd())
              or vim.fn.getcwd()
            local function exists(p)
              return vim.uv.fs_stat(p) ~= nil
            end
            local candidates = {
              (vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python")) or nil,
              root .. "/.venv/bin/python",
              root .. "/venv/bin/python",
            }
            for _, p in ipairs(candidates) do
              if p and exists(p) then
                conf.settings.python.pythonPath = p
                break
              end
            end
          end,
        },
      },
    },
  },

  -- Отладка Python (debugpy) + удобные бинды
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python"
      require("dap-python").setup(python)
      local map = vim.keymap.set
      map("n", "<leader>dd", function()
        require("dap").continue()
      end, { desc = "DAP: Continue" })
      map("n", "<leader>db", function()
        require("dap").toggle_breakpoint()
      end, { desc = "DAP: Toggle BP" })
      map("n", "<leader>dO", function()
        require("dap").step_over()
      end, { desc = "DAP: Step Over" })
      map("n", "<leader>di", function()
        require("dap").step_into()
      end, { desc = "DAP: Step Into" })
      map("n", "<leader>do", function()
        require("dap").step_out()
      end, { desc = "DAP: Step Out" })
    end,
  },
}
