-- Catppuccin flavors: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

-- require("tokyonight").setup({
--    transparent = true,
-- })

-- vim.cmd([[colorscheme tokyonight-night]])

require('catppuccin').setup {
    flavour = "auto",
    transparent_background = true, -- disables setting the background color.
    integrations = {
      barbecue = {
        dim_dirname = true, -- directory name is dimmed by default
        bold_basename = true,
        dim_context = false,
        alt_background = false,
      },
      blink_cmp = {
        style = 'bordered',
      },
      lsp_saga = false,
      mason = false,
      neogit = true,
      dap = true,
      dap_ui = true,
      which_key = false,
      fzf = true,
        }
  }


  vim.cmd.colorscheme "catppuccin-nvim"


