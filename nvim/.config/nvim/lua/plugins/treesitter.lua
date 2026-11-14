local treesitter = require("nvim-treesitter")

local ensure_installed = {
    "go", "rust", "c", "cpp", "cmake", "toml",
    "typescript", "javascript", "tsx", "python",
    "html", "css", "json", "bash",
    "markdown", "markdown_inline",
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
end
