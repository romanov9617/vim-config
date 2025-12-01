return {
  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.flamingo },
          TabLineSel = { bg = colors.pink },
          CmpBorder = { fg = colors.surface2 },
          Pmenu = { bg = colors.none },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        native_lsp = { enabled = true }, -- семантические токены LSP
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    },
  },
}
