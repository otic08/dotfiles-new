-- vim ui2

vim.g.mapleader = " "

require('vim._core.ui2').enable({
    enable = true,
    msg = {
        target = "cmd", -- options: cmd(classic), msg(similar to noice)
        pager = { height = 1 },
        msg   = { height = 0.5},
        dialog = { height = 0.5 },
    --    cmd    = { height = 0.5 },
    },
})

require("options")
require("commands")
require("plugins")
require("keymaps")

