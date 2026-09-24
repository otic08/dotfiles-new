require("sidekick").setup({
    cli = {
        mux = {
            backend = "tmux",
            enabled = true,
        },
    },
})

-- NES: jump to or apply next edit suggestion, then inline completion, else normal <Tab>
vim.keymap.set({ "i", "n" }, "<tab>", function()
    if require("sidekick").nes_jump_or_apply() then
        return
    end
    if vim.lsp.inline_completion.get() then
        return
    end
    return "<tab>"
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

-- enable native inline completions (ghost text) when the server supports them
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_inline_completion", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
            vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
        end
    end,
})

-- AI CLI
vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function()
    require("sidekick.cli").focus()
end, { desc = "Sidekick Focus" })
vim.keymap.set("n", "<leader>aa", function()
    require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", function()
    require("sidekick.cli").select({ filter = { installed = true } })
end, { desc = "Select CLI" })
vim.keymap.set("n", "<leader>ad", function()
    require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })
vim.keymap.set({ "x", "n" }, "<leader>at", function()
    require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })
vim.keymap.set("n", "<leader>af", function()
    require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })
vim.keymap.set("x", "<leader>av", function()
    require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function()
    require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })
