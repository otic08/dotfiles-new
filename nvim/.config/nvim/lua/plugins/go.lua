require("gopher").setup({})

require("godoc").setup({
    picker = {
        type = "fzf_lua",
    },
})

vim.api.nvim_create_autocmd("PackChanged", {
    pattern = "*",
    callback = function(ev)
        if ev.data.spec.name == "gopher.nvim" and vim.tbl_contains({ "install", "update" }, ev.data.kind) then
            vim.cmd.GoInstallDeps()
        end
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    pattern = "*",
    callback = function(ev)
        if ev.data.spec.name == "godoc.nvim" and vim.tbl_contains({ "install", "update" }, ev.data.kind) then
            vim.system({
                "go",
                "install",
                "github.com/lotusirous/gostdsym/stdsym@latest",
            }, function() end)
        end
    end,
})
