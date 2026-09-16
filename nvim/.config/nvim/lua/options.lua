vim.g.netrw_banner = 0

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = false
vim.opt.wrap = false

-- backup and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- search
vim.opt.inccommand = "split"

-- UI
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- folding
vim.o.foldenable = true
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldcolumn = "0"

-- window splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- misc
--vim.opt.guicursor = ""
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "0"
vim.opt.clipboard:append("unnamedplus")
vim.opt.mouse = "a"

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})


-- setting diagnostics
local diagnostic_signs = {
	[vim.diagnostic.severity.ERROR] = "☒",
	[vim.diagnostic.severity.WARN] = "⚠",
	[vim.diagnostic.severity.HINT] = "⚡",
	[vim.diagnostic.severity.INFO] = "ⓘ",
}
vim.diagnostic.config({
	signs = { text = diagnostic_signs },
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
	},
})
