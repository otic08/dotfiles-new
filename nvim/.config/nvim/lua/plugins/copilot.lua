vim.g.copilot_nes_debounce = 500

require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 15,
        trigger_on_accept = true,
        keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
            toggle_auto_trigger = false,
        },
    },
    nes = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept_and_goto = "<leader>p",
            accept = false,
            dismiss = "<Esc>",
        },
    },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuOpen",
    callback = function()
        vim.b.copilot_suggestion_hidden = true
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuClose",
    callback = function()
        vim.b.copilot_suggestion_hidden = false
    end,
})
