require("which-key").setup({
    -- LazyVim default group spec, adapted to this config's prefixes
    spec = {
        {
            mode = { "n", "v" },
            { "<leader>a", group = "ai" },
            { "<leader>b", group = "buffer" },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>l", group = "lsp" },
            { "<leader>q", group = "quit/session" },
            { "<leader>r", group = "restart" },
            { "<leader>s", group = "split/search" },
            { "<leader>t", group = "tabs" },
            { "<leader>u", group = "ui" },
            { "<leader>w", group = "windows" },
            { "<leader>x", group = "diagnostics/quickfix" },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "z", group = "fold" },
        },
    },
})
