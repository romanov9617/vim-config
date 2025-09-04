return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  { "folke/which-key.nvim", event = "VeryLazy" },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "xemptuous/sqlua.nvim",
    lazy = true,
    cmd = "SQLua",
    config = function()
      require("sqlua").setup()
    end,
  },
}
