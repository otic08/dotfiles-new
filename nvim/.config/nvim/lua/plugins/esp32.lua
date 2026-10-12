require("esp32").setup()

vim.lsp.config("clangd", require("esp32").lsp_config())
