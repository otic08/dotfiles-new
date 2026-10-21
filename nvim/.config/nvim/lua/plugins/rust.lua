local codelldb_root = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
if vim.fn.has("mac") == 1 then
    liblldb_path = codelldb_root .. "lldb/lib/liblldb.dylib"
end

local cwd = vim.fn.getcwd()
local rust_project_path = cwd .. "/rust-project.json"

local ra_settings
if vim.uv.fs_stat(rust_project_path) then
    ra_settings = {
        linkedProjects = { rust_project_path },
        check = { enable = false },
    }
else
    ra_settings = {
        checkOnSave = {
            command = "clippy",
        },
    }
end

local dap_cfg = {}
if vim.uv.fs_stat(codelldb_path) then
    local cfg = require("rustaceanvim.config")
    dap_cfg.adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
end

vim.g.rustaceanvim = {
    dap = dap_cfg,
    inlay_hints = {
        highlight = "NonText",
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
    server = {
        on_attach = function(_, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

            local function map(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
            end

            map("<leader>rh", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Rust Hover Actions")
            map("<leader>ra", function() vim.cmd.RustLsp("codeAction") end, "Rust Code Action")
            map("<leader>rr", function() vim.cmd("wa") vim.cmd.RustLsp({ "runnables" }) end, "Rust Runnables")
            map("<leader>rd", function() vim.cmd("wa") vim.cmd.RustLsp({ "debuggables" }) end, "Rust Debuggables")
            map("<leader>rE", function() vim.cmd.RustLsp({ "explainError" }) end, "Rust Explain Error")
            map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Rust Expand Macro")
            map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
        end,
        default_settings = {
            ["rust-analyzer"] = ra_settings,
        },
    },
}

local crates = require("crates")
crates.setup({})

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function(ev)
        local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end

        map("<leader>rct", crates.toggle, "Toggle crates")
        map("<leader>rcr", crates.reload, "Reload crates")
        map("<leader>rcv", crates.show_versions_popup, "Show versions popup")
        map("<leader>rcf", crates.show_features_popup, "Show features popup")
        map("<leader>rcd", crates.show_dependencies_popup, "Show dependencies popup")
        map("<leader>rcu", crates.update_crate, "Update crate")
        map("<leader>rca", crates.update_all_crates, "Update all crates")
        map("<leader>rcU", crates.upgrade_crate, "Upgrade crate")
        map("<leader>rcA", crates.upgrade_all_crates, "Upgrade all crates")
        map("<leader>rce", crates.expand_plain_crate_to_inline_table, "Expand crate to inline table")
        map("<leader>rcE", crates.extract_crate_into_table, "Extract crate into table")
        map("<leader>rcH", crates.open_homepage, "Open crate homepage")
        map("<leader>rcR", crates.open_repository, "Open crate repository")
        map("<leader>rcD", crates.open_documentation, "Open crate documentation")
        map("<leader>rcC", crates.open_crates_io, "Open crates.io")
    end,
})
