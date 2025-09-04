return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite" },
    keys = {
      { "<leader>gs", ":Git status<CR>", desc = "Git Status (fugitive)" },
      { "<leader>gd", ":Gdiffsplit<CR>", desc = "Git Diffsplit" },
    },
  },
}
