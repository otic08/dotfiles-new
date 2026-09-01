-- Oil.nvim
require("oil").setup({
	keymaps = {
		["<C-h>"] = "<C-w>h",
		["<BS>"] = "<C-w>h", -- only if your terminal sends Ctrl-h as BS
		["<C-l>"] = "<C-w>l",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
	},
	columns = {
		{ "mtime", highlight = "Comment" } },
	view_options = {
		show_hidden = true,
		sort = {
			{ "type",  "asc" },
			{ "mtime", "desc" },
		}
	},
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

