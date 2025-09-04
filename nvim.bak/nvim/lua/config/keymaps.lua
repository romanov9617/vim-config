-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go to Definition" })
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "Find References" })
--
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Open advanced diagnostic" })
map("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", { desc = "Go Fill Struct" })
map("n", "<leader>gfp", "<cmd>GoFixPlurals<CR>", { desc = "Go Fix Plurals" })
map("n", "<leader>gfe", "<cmd>GoIfErr<CR>", { desc = "Go Fill IfErr" })
map("n", "<leader>gc", "<cmd>GoCmt<CR>", { desc = "Go Add Docstring" })
map("n", "<leader>ta", "<cmd>GoAddTag<CR>", { desc = "Go Add Tags" })
map("n", "<leader>td", "<cmd>GoRmTag<CR>", { desc = "Go Remove Tags" })
