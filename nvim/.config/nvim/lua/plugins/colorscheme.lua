-- Catppuccin flavors: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

-- require("tokyonight").setup({
--    transparent = true,
-- })

-- vim.cmd([[colorscheme tokyonight-night]])

require('onedark').setup {
    style = 'darker'
}
require('onedark').load()
vim.cmd.colorscheme "onedark"
