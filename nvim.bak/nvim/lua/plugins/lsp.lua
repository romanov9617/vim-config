vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.code_action({
      context = {
        only = { "source.organizeImports" },
        diagnostics = {},
      },
      apply = true,
    })
  end,
})
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        gopls = {},
        rust_analyzer = {},
      },
    },
  },
  { "onsails/lspkind-nvim" },
}
