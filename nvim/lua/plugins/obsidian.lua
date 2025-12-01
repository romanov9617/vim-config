return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    -- грузим только для файлов из указанных вольтов
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/knowledges/knowledges/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/knowledges/knowledges/**.md",
      "BufReadPre " .. vim.fn.expand("~") .. "/code/redsoft/knowledge_base/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/code/redsoft/knowledge_base/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- необязательно, но удобно:
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          -- без завершающего слэша — так надёжнее для детекции
          path = vim.fn.expand("~") .. "/knowledges/knowledges",
        },
        {
          name = "work",
          path = vim.fn.expand("~") .. "/code/redsoft/knowledge_base",
        },
      },
      -- опциональные приятности:
      notes_subdir = "notes",
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      picker = { name = "telescope" },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      -- куда складывать вложения, если вставляешь картинки
      attachments = { img_folder = "assets/img" },
      ui = { enable = true },
    },
    keys = {
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: quick switch" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: new note" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: search" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Obsidian: today" },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
