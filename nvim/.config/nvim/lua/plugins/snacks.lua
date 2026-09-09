require("snacks").setup({
	picker = { enabled = true },
	explorer = { enabled = true },
	lazygit = { enabled = true },
})


vim.keymap.set("n", "<leader>ff", Snacks.picker.files)
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep)
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers)
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics)
vim.keymap.set("n", "<leader>fs", Snacks.picker.lsp_symbols)
vim.keymap.set("n", "<leader>fe", function() Snacks.explorer() end)
vim.keymap.set("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols)
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
vim.keymap.set("n", "gr", Snacks.picker.lsp_references)
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end)
