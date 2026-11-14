local telescope = require("telescope")

telescope.setup({
    defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = { preview_width = 0.5 },
        },
    },
})
