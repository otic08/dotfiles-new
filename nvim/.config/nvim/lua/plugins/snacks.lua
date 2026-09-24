require("snacks").setup({
	picker = { enabled = true },
	explorer = { enabled = true },
	lazygit = { enabled = true },
	gitbrowse = { enabled = true },
	words = { enabled = true },
	rename = { enabled = true },
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

-- git (LazyVim defaults under <leader>g)
vim.keymap.set("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = Snacks.git.get_root() })
end, { desc = "Lazygit (Root Dir)" })
vim.keymap.set("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
vim.keymap.set("n", "<leader>gl", function()
    Snacks.picker.git_log({ cwd = Snacks.git.get_root() })
end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
vim.keymap.set({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
vim.keymap.set({ "n", "x" }, "<leader>gY", function()
    Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (hunks)" })
