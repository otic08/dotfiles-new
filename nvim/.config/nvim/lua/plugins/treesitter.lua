local treesitter = require("nvim-treesitter")

local ensure_installed = {
    "go", "rust", "c", "cpp", "cmake", "toml",
    "typescript", "javascript", "tsx", "python",
    "html", "css", "json", "bash",
    "http", "dockerfile",
}

treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype

        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
            return
        end

        local ok_add = pcall(vim.treesitter.language.add, lang)
        if not ok_add then
            return
        end

        pcall(vim.treesitter.start, buf, lang)
    end,
})

local ok_ts_to, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")
if ok_ts_to then
    ts_textobjects.setup({
        select = {
            lookahead = true,
        },
        move = {
            set_jumps = true,
        },
    })

    local ts_select = require("nvim-treesitter-textobjects.select")
    local ts_move = require("nvim-treesitter-textobjects.move")

    local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ar"] = "@return.outer",
        ["ir"] = "@return.inner",
        ["ak"] = "@comment.outer",
        ["ik"] = "@comment.inner",
    }
    for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
            ts_select.select_textobject(query)
        end, { desc = "TS: " .. query })
    end

    local move_maps = {
        goto_next_start = {
            ["]a"] = "@assignment.outer",
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]k"] = "@comment.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
            ["]b"] = "@block.outer",
            ["]p"] = "@parameter.outer",
        },
        goto_next_end = {
            ["]A"] = "@assignment.outer",
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]K"] = "@comment.outer",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
            ["]B"] = "@block.outer",
            ["]P"] = "@parameter.outer",
        },
        goto_previous_start = {
            ["[a"] = "@assignment.outer",
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[k"] = "@comment.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
            ["[b"] = "@block.outer",
            ["[p"] = "@parameter.outer",
        },
        goto_previous_end = {
            ["[A"] = "@assignment.outer",
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[K"] = "@comment.outer",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
            ["[B"] = "@block.outer",
            ["[P"] = "@parameter.outer",
        },
    }
    for fn_name, mappings in pairs(move_maps) do
        for key, query in pairs(mappings) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
                ts_move[fn_name](query)
            end, { desc = "TS: " .. fn_name .. " " .. query })
        end
    end
end
