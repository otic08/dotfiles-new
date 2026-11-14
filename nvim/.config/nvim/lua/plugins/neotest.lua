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
