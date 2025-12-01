return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        -- go = { "gofmt", "goimports" },
        rust = { "rustfmt" },
        json = { "prettier" },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "go" then
          return nil
        end
        return { timeout_ms = 1000, lsp_fallback = true }
      end,
    },
  },
}
