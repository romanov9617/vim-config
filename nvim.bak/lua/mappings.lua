require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document Symbols" })
map("n", "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace Symbols" })
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go to Definition" })
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "Find References" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Open advanced diagnostic" })
map("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", { desc = "Go Fill Struct" })
map("n", "<leader>gfp", "<cmd>GoFixPlurals<CR>", { desc = "Go Fix Plurals" })
map("n", "<leader>gfe", "<cmd>GoIfErr<CR>", { desc = "Go Fill IfErr" })
map("n", "<leader>gc", "<cmd>GoCmt<CR>", { desc = "Go Add Docstring" })
map("n", "<leader>ta", "<cmd>GoAddTag<CR>", { desc = "Go Add Tags" })
map("n", "<leader>td", "<cmd>GoRmTag<CR>", { desc = "Go Remove Tags" })
