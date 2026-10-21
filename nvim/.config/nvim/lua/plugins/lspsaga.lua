local ui_opts = {}
local ok_cat, cat_saga = pcall(require, "catppuccin.groups.integrations.lsp_saga")
if ok_cat then
    ui_opts.kind = cat_saga.custom_kind()
    ui_opts.colors = cat_saga.custom_colors()
end

require("lspsaga").setup({
    ui = ui_opts,
    symbol_in_winbar = {
        enable = false,
    },
    lightbulb = {
        virtual_text = false,
    },
})
