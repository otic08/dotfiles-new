require("neotest-gtest").setup({})

require("neotest").setup({
    adapters = {
        require("neotest-gtest"),
        require("neotest-python")({
            dap = { justMyCode = false },
        }),
        require("rustaceanvim.neotest"),
    },
})

vim.keymap.set("n", "<leader>Tr", function()
    require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>Tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run test file" })

vim.keymap.set("n", "<leader>Td", function()
    require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>Ts", function()
    require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })

vim.keymap.set("n", "<leader>To", function()
    require("neotest").output_panel.toggle()
end, { desc = "Toggle test output panel" })
