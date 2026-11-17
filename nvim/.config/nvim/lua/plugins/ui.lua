-- Folds (nvim-ufo)
vim.o.foldcolumn = "1"
vim.o.foldnestmax = 0
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

require("ufo").setup({
    provider_selector = function()
        return { "treesitter", "indent" }
    end,
})

local no_foldcolumn = {
    startup = true,
    alpha = true,
    dashboard = true,
    ["neo-tree"] = true,
    Trouble = true,
    lazy = true,
    help = true,
}
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("UfoDisableFoldcolumn", { clear = true }),
    callback = function()
        if no_foldcolumn[vim.bo.filetype] then
            vim.opt_local.foldcolumn = "0"
        end
    end,
})

-- Status column (statuscol.nvim)
local builtin = require("statuscol.builtin")
require("statuscol").setup({
    relculright = true,
    ft_ignore = { "help", "vim", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "toggleterm" },
    segments = {
        {
            sign = { name = { "Diagnostic" }, namespace = { "diagnostic" }, maxwidth = 1, colwidth = 1 },
            click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        {
            sign = { name = { "Dap*" }, maxwidth = 1, colwidth = 1 },
            click = "v:lua.ScSa",
        },
        {
            sign = {
                name = { "GitSigns*" },
                namespace = { "gitsigns" },
                maxwidth = 1,
                colwidth = 1,
            },
            click = "v:lua.ScSa",
        },
    },
})

-- Indentation guides (indent-blankline.nvim)
require("ibl").setup({})

-- Rainbow delimiters (rainbow-delimiters.nvim)
local rainbow_delimiters = require("rainbow-delimiters")
require("rainbow-delimiters.setup").setup({
    strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
    },
    query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
    },
    priority = {
        [""] = 110,
        lua = 210,
    },
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
    },
})

-- Todo comments (todo-comments.nvim)
require("todo-comments").setup({
    search = { pattern = [[\b(KEYWORDS)\b(\([^\)]*\))?:?]] },
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?)%(:|\s|$)]] },
})
-- Git links (gitlinker.nvim)
require("gitlinker").setup({})
