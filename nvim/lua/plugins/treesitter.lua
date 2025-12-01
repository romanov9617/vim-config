return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
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
      auto_install = true,
      indent = { enable = true },
    },
  },
}
