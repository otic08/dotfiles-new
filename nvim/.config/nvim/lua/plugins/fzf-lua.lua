local fzf = require("fzf-lua")

fzf.setup({})

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "LSP Document Symbols" })
vim.keymap.set("n", "<leader>fS", fzf.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
