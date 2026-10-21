require("neogen").setup({})
vim.keymap.set("n", "<leader>Ag", function()
    require("neogen").generate()
end, { desc = "Generate Documentation (Neogen)" })

require("mini.pairs").setup()
require("mini.bracketed").setup()
require("textcase").setup({})
require("guess-indent").setup({})
