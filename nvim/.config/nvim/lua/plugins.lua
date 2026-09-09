vim.pack.add({
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/tpope/vim-fugitive",
    { src = "https://github.com/mfussenegger/nvim-dap", version = "b516f20b" },
    { src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
    "https://github.com/meanderingprogrammer/render-markdown.nvim",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads})
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/karb94/neoscroll.nvim",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/rachartier/tiny-cmdline.nvim"
})

require("plugins.colorscheme")
require("plugins.mini")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.dap")
require("plugins.render-markdown")
require("plugins.neoscroll")
require("plugins.oil")
require("plugins.snacks")
require("plugins.lualine")
require("plugins.blink")
require("plugins.tiny-cmdline")
