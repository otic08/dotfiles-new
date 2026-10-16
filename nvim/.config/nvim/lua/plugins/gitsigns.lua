require("gitsigns").setup({
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        map("n", "]h", function() gitsigns.nav_hunk("next") end, { desc = "Next git hunk" })
        map("n", "[h", function() gitsigns.nav_hunk("prev") end, { desc = "Prev git hunk" })

        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage selected hunk" })
        map("v", "<leader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset selected hunk" })
        map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })
        map("n", "<leader>gt", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
        map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })

        map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
    end,
})
