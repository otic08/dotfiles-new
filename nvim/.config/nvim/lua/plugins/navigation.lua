local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>ha", function()
    harpoon:list():add()
end, { desc = "Harpoon: Add file" })

vim.keymap.set("n", "<leader>he", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Quick menu" })

vim.keymap.set("n", "<leader>hp", function()
    harpoon:list():prev()
end, { desc = "Harpoon: Previous mark" })

vim.keymap.set("n", "<leader>hn", function()
    harpoon:list():next()
end, { desc = "Harpoon: Next mark" })

vim.keymap.set("n", "<leader>hrc", function()
    harpoon:list():remove()
end, { desc = "Harpoon: Remove current buffer" })

for i = 1, 9 do
    vim.keymap.set("n", "<leader>h" .. i, function()
        harpoon:list():select(i)
    end, { desc = "Harpoon: Select mark " .. i })

    vim.keymap.set("n", "<leader>hr" .. i, function()
        harpoon:list():remove_at(i)
    end, { desc = "Harpoon: Remove mark " .. i })
end

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", { desc = "Leap from window" })

local spectre = require("spectre")
spectre.setup()

vim.keymap.set("n", "<leader>so", function()
    spectre.open()
end, { desc = "Spectre: Open search & replace" })

vim.keymap.set("n", "<leader>sw", function()
    spectre.open_visual({ select_word = true })
end, { desc = "Spectre: Search current word" })

vim.keymap.set("v", "<leader>sw", function()
    spectre.open_visual()
end, { desc = "Spectre: Search selection" })

vim.keymap.set("n", "<leader>sf", function()
    spectre.open_file_search({ select_word = true })
end, { desc = "Spectre: Search in current file" })
