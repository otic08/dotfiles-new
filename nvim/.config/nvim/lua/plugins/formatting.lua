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

local function format_buffer()
    conform.format({
        bufnr = vim.api.nvim_get_current_buf(),
        lsp_format = "fallback",
        timeout_ms = 500,
    })
end

vim.keymap.set({ "n", "v" }, "<leader>f", format_buffer, { desc = "Format buffer (Conform)" })
vim.keymap.set({ "n", "v" }, "<leader>fm", format_buffer, { desc = "Format buffer (Conform)" })
vim.keymap.set({ "n", "v" }, "<leader>bf", function()
    format_buffer()
    vim.cmd("silent! write")
end, { desc = "Format and save buffer" })
