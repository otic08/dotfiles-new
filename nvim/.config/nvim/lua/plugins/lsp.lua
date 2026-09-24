require("mason").setup()

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

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

    map("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
    map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition", has = "definition" })
    map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
    map("n", "gI", function() Snacks.picker.lsp_implementations() end,
        { desc = "Goto Implementation", has = "implementation" })
    map("n", "gy", function() Snacks.picker.lsp_type_definitions() end,
        { desc = "Goto T[y]pe Definition", has = "typeDefinition" })
    map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration", has = "declaration" })
    map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
    map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", has = "codeAction" })
    map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens", has = "codeLens" })
    map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens", has = "codeLens" })
    map("n", "<leader>cR", function() Snacks.rename.rename_file() end,
        { desc = "Rename File", has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } })
    map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", has = "rename" })
    map("n", "<leader>cA", function()
        vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
    end, { desc = "Source Action", has = "codeAction" })

    if Snacks.words and Snacks.words.is_enabled({ buf = bufnr }) then
        map("n", "]]", function() Snacks.words.jump(vim.v.count1) end,
            { desc = "Next Reference", has = "documentHighlight" })
        map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end,
            { desc = "Prev Reference", has = "documentHighlight" })
        map({ "n", "t" }, "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end,
            { desc = "Next Reference", has = "documentHighlight" })
        map({ "n", "t" }, "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end,
            { desc = "Prev Reference", has = "documentHighlight" })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
            lsp_keymaps(event.buf, client)
        end
    end,
})

-- LazyVim-style diagnostic keymaps
local diagnostic_goto = function(next, severity)
    return function()
        vim.diagnostic.jump({ count = next and 1 or -1, severity = severity, float = true })
    end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, vim.diagnostic.severity.WARN), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
vim.lsp.config("*", { capabilities = capabilities })

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
    "copilot",
})
