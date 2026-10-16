require("which-key").setup({
    preset = "helix",
    -- LazyVim default group spec, adapted to this config's prefixes
    spec = {
        {
            mode = { "n", "v" },
            { "<leader>b", group = "buffer" },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug/delete" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>l", group = "lsp" },
            { "<leader>m", group = "markdown" },
            { "<leader>r", group = "restart" },
            { "<leader>s", group = "split/search" },
            { "<leader>t", group = "tabs" },
            { "<leader>u", group = "ui" },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "z", group = "fold" },
        },
    },
})
