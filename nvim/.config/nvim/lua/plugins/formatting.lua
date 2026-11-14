local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "isort", "black", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        cpp = { "clang-format" },
        c = { "clang-format" },
        cmake = { "cmake_format" },
        sh = { "shfmt" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        html = { "prettier" },
        css = { "prettier" },
        toml = { "taplo" },
    },
    formatters = {
        prettier = { prepend_args = { "--ignore-path", ".prettierignore" } },
    },
})
