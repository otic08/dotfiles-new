local neotree = require("neo-tree")

neotree.setup({})

vim.keymap.set("n", "<leader>fe", function()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        path = vim.uv.cwd()
    end

    local dir = vim.fn.fnamemodify(path, ":h")
    vim.cmd(("Neotree toggle %s"):format(vim.fn.fnameescape(dir)))
end, { desc = "File Explorer" })
