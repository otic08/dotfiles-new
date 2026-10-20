vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    { src = "https://github.com/mfussenegger/nvim-dap", version = "b516f20b" },
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/meanderingprogrammer/render-markdown.nvim",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads})
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/karb94/neoscroll.nvim",
    "https://github.com/rachartier/tiny-cmdline.nvim",
    "https://github.com/navarasu/onedark.nvim",
    "https://github.com/esmuellert/codediff.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/xheisenbugx/org.nvim",
    "https://github.com/NeogitOrg/neogit",
    "https://github.com/nvim-mini/mini.files",

    {src =  "https://github.com/catppuccin/nvim", name  = "catppuccin"},
})

require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.dap")
require("plugins.render-markdown")
require("plugins.neoscroll")
require("plugins.lualine")
require("plugins.blink")
require("plugins.tiny-cmdline")
require("plugins.fzf-lua")
require("plugins.codediff")
require("plugins.gitsigns")
require("plugins.neogit")
require("plugins.mini-files")
require("plugins.which-key")
require("plugins.org")
