return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "",
        },
        update_in_insert = false,
        severity_sort = true,
      },
      servers = {
        gopls = {},
        pyright = {},
      },
    },
  },
}
