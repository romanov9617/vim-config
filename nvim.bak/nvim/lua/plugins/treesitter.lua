return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "go",
        "rust",
        "lua",
        "vim",
        "bash",
        "html",
        "css",
        "json",
        "sql",
      },
      highlight = { enable = true },
    },
  },
}
