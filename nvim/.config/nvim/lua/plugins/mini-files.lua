local MiniFiles = require("mini.files")

MiniFiles.setup({
    windows = {
        preview = true,
    },
})

local function toggle_mini_files(path)
    if MiniFiles.close() == nil then
        MiniFiles.open(path)
    end
end

vim.keymap.set("n", "<leader>fe", function()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        path = vim.uv.cwd()
    end

    toggle_mini_files(path)
end, { desc = "File Explorer" })
