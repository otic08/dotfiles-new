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
    {src =  "https://github.com/catppuccin/nvim", name  = "catppuccin"},
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    {src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3')},
    "https://github.com/SmiteshP/nvim-navic",
    "https://github.com/utilyre/barbecue.nvim",
    "https://github.com/nvimdev/lspsaga.nvim",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://github.com/saecki/crates.nvim",
    "https://github.com/p00f/clangd_extensions.nvim",
    "https://github.com/Civitasv/cmake-tools.nvim",
    -- Point 3: Mason & formatting automation
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/stevearc/conform.nvim",
    -- Point 4: Testing, diagnostics & code navigation
    "https://github.com/antoinemadec/FixCursorHold.nvim",
    "https://github.com/alfaix/neotest-gtest",
    "https://github.com/nvim-neotest/neotest-python",
    "https://github.com/nvim-neotest/neotest",
    "https://github.com/folke/trouble.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    -- Point 5: Code generation/editing, navigation/search, UI & folding
    "https://github.com/danymat/neogen",
    "https://github.com/echasnovski/mini.pairs",
    "https://github.com/echasnovski/mini.bracketed",
    "https://github.com/johmsalas/text-case.nvim",
    "https://github.com/nmac427/guess-indent.nvim",
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
    "https://github.com/tpope/vim-repeat",
    "https://codeberg.org/andyg/leap.nvim",
    "https://github.com/nvim-pack/nvim-spectre",
    "https://github.com/kevinhwang91/promise-async",
    "https://github.com/kevinhwang91/nvim-ufo",
    "https://github.com/luukvbaal/statuscol.nvim",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/HiPhish/rainbow-delimiters.nvim",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/linrongbin16/gitlinker.nvim",
})

require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.lspsaga")
require("plugins.rust")
require("plugins.clangd")
require("plugins.lsp")
require("plugins.formatting")
require("plugins.dap")
require("plugins.neotest")
require("plugins.trouble")
require("plugins.editing")
require("plugins.navigation")
require("plugins.ui")
require("plugins.render-markdown")
require("plugins.neoscroll")
require("plugins.lualine")
require("plugins.blink")
require("plugins.tiny-cmdline")
require("plugins.fzf-lua")
require("plugins.codediff")
require("plugins.gitsigns")
require("plugins.neogit")
require("plugins.which-key")
require("plugins.org")
require("plugins.neo-tree")
require("plugins.barbecue")
