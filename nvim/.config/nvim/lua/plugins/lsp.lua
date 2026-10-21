require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        -- LSPs
        "lua-language-server",
        "basedpyright",
        "clangd",
        "neocmakelsp",
        "ruff",
        "json-lsp",
        "marksman",
        "taplo",
        -- DAPs
        "codelldb",
        "cpptools",
        "debugpy",
        -- Formatters & Linters
        "stylua",
        "clang-format",
        "cmakelang",
        "prettier",
        "shfmt",
        "shellcheck",
        "markdownlint-cli2",
    },
    auto_update = false,
    run_on_start = true,
})

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", "<cmd>Lspsaga show_line_diagnostics<cr>", { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

-- LazyVim-style LSP keymaps, attached per-buffer and gated on server capabilities
-- (mirrors lazyvim/plugins/lsp/keymaps.lua)
local function lsp_keymaps(bufnr, client)
    local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        if opts.has then
            local methods = type(opts.has) == "table" and opts.has or { opts.has }
            local supported = false
            for _, method in ipairs(methods) do
                if client:supports_method("textDocument/" .. method) then
                    supported = true
                    break
                end
            end
            if not supported then
                return
            end
            opts.has = nil
        end
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
    map("n", "gd", "<cmd>Lspsaga goto_definition<cr>", { desc = "Goto Definition", has = "definition" })
    map("n", "gp", "<cmd>Lspsaga peek_definition<cr>", { desc = "Peek Definition", has = "definition" })
    map("n", "gr", "<cmd>Lspsaga finder<cr>", { desc = "References & Implementations", nowait = true, has = { "references", "implementation" } })
    map("n", "gI", "<cmd>Lspsaga finder imp<cr>", { desc = "Goto Implementation", has = "implementation" })
    map("n", "gy", "<cmd>Lspsaga goto_type_definition<cr>", { desc = "Goto T[y]pe Definition", has = "typeDefinition" })
    map("n", "gY", "<cmd>Lspsaga peek_type_definition<cr>", { desc = "Peek T[y]pe Definition", has = "typeDefinition" })
    map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration", has = "declaration" })
    map("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "Hover" })
    map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
    map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
    map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", { desc = "Code Action", has = "codeAction" })
    map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens", has = "codeLens" })
    map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens", has = "codeLens" })
    map("n", "<leader>cr", "<cmd>Lspsaga rename<cr>", { desc = "Rename", has = "rename" })
    map("n", "<leader>cR", "<cmd>Lspsaga rename ++project<cr>", { desc = "Rename (Project)", has = "rename" })
    map("n", "<leader>co", "<cmd>Lspsaga outline<cr>", { desc = "Symbols Outline", has = "documentSymbol" })
    map("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", { desc = "Incoming Calls", has = "prepareCallHierarchy" })
    map("n", "<leader>cO", "<cmd>Lspsaga outgoing_calls<cr>", { desc = "Outgoing Calls", has = "prepareCallHierarchy" })
    map("n", "<leader>cA", function()
        vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
    end, { desc = "Source Action", has = "codeAction" })

    if client.name == "clangd" then
        map("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (C/C++)" })
        map("n", "<leader>lh", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (C/C++)" })
        map("n", "<leader>cH", "<cmd>ClangdTypeHierarchy<cr>", { desc = "Clangd Type Hierarchy" })
        map("n", "<leader>cM", "<cmd>ClangdMemoryUsage<cr>", { desc = "Clangd Memory Usage" })
        map("n", "<leader>cS", "<cmd>ClangdSymbolInfo<cr>", { desc = "Clangd Symbol Info" })
    end

end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
            return
        end
        lsp_keymaps(event.buf, client)

        if client:supports_method("textDocument/documentHighlight", event.buf) then
            local buf = event.buf
            local hl_group = vim.api.nvim_create_augroup("lsp_highlight_" .. buf, { clear = true })
            local timer = assert(vim.uv.new_timer())

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = hl_group,
                buffer = buf,
                callback = function()
                    timer:stop()
                    timer:start(100, 0, vim.schedule_wrap(function()
                        if vim.api.nvim_buf_is_valid(buf) then
                            vim.lsp.buf.clear_references()
                            vim.lsp.buf.document_highlight()
                        end
                    end))
                end,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = hl_group,
                buffer = buf,
                callback = function()
                    if not timer:is_closing() then
                        timer:stop()
                        timer:close()
                    end
                    vim.lsp.buf.clear_references()
                    pcall(vim.api.nvim_del_augroup_by_name, "lsp_highlight_" .. buf)
                end,
            })
        end
    end,
})

-- LazyVim-style diagnostic keymaps using lspsaga
local diagnostic_goto = function(next, severity)
    return function()
        local opts = severity and { severity = severity } or nil
        if next then
            require("lspsaga.diagnostic"):goto_next(opts)
        else
            require("lspsaga.diagnostic"):goto_prev(opts)
        end
    end
end
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>cD", "<cmd>Lspsaga show_buf_diagnostics<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>cw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, vim.diagnostic.severity.WARN), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
vim.lsp.config("*", { capabilities = capabilities })

local mason_clangd = vim.fn.stdpath("data") .. "/mason/bin/clangd"
local clangd_bin = vim.uv.fs_stat(mason_clangd) and mason_clangd or "clangd"

vim.lsp.config("clangd", {
    filetypes = { "c", "cpp", "cc", "mpp", "ixx", "objc", "objcpp", "cuda" },
    cmd = {
        clangd_bin,
        "--clang-tidy",
        "--header-insertion=never",
        "--offset-encoding=utf-16",
    },
    on_attach = function(_, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

--vim.lsp.config("copilot", {
--    root_markers = {},
--})

vim.lsp.enable({
    "lua_ls",
    "basedpyright",
    "clangd",
    "neocmakelsp",
    "jsonls",
    "marksman",
    "taplo",
    "ruff",
 --   "copilot",
})
