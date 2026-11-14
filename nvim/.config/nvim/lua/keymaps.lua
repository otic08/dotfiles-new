local wk = require("which-key")

vim.g.mapleader = " "

-- helpers shared by mappings below
local function format_buffer()
    require("conform").format({
        bufnr = vim.api.nvim_get_current_buf(),
        lsp_format = "fallback",
        timeout_ms = 500,
    })
end

local function diagnostic_goto(next, severity)
    return function()
        local opts = severity and { severity = severity } or nil
        if next then
            require("lspsaga.diagnostic"):goto_next(opts)
        else
            require("lspsaga.diagnostic"):goto_prev(opts)
        end
    end
end

local function select_dap_config()
    local configs = require("dap").configurations[vim.bo.filetype] or {}
    vim.ui.select(configs, {
        prompt = "Select DAP configuration",
        format_item = function(config)
            return config.name
        end,
    }, function(config)
        if config then
            require("dap").run(config)
        end
    end)
end

local mdserve_job = nil
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if mdserve_job then
            vim.fn.jobstop(mdserve_job)
        end
    end,
})

local spec = {
    -- editing
    { "<leader><leader>", function() vim.cmd("so") end, desc = "Source current file" },
    { "J", "mzJ`z", desc = "Join lines, keep cursor position" },
    { "<C-d>", "<C-d>zz", desc = "Move down in buffer with cursor centered" },
    { "<C-u>", "<C-u>zz", desc = "Move up in buffer with cursor centered" },
    { "n", "nzzzv", desc = "Next search result, centered" },
    { "N", "Nzzzv", desc = "Prev search result, centered" },
    { "<C-c>", "<Esc>", mode = "i", desc = "Exit insert mode" },
    { "<C-c>", "<cmd>nohl<CR>", desc = "Clear search hl" },
    { "x", '"_x', desc = "Delete char without yanking" },
    { "p", [["_dP]], mode = "x", desc = "Paste over selection without losing yank" },
    { "<", "<gv", mode = "v", desc = "Dedent selection" },
    { ">", ">gv", mode = "v", desc = "Indent selection" },
    { "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move lines down in visual selection" },
    { "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move lines up in visual selection" },
    { "<leader>d", [["_d]], mode = { "n", "v" }, desc = "Delete without yanking" },
    { "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Replace word cursor is on globally" },
    { "<leader>X", "<cmd>!chmod +x %<CR>", desc = "Make file executable" },

    -- formatting
    { "<leader>f", format_buffer, mode = { "n", "v" }, desc = "Format buffer (Conform)" },
    { "<leader>fm", format_buffer, mode = { "n", "v" }, desc = "Format buffer (Conform)" },
    { "<leader>bf", function()
        format_buffer()
        vim.cmd("silent! write")
    end, mode = { "n", "v" }, desc = "Format and save buffer" },

    -- tabs
    { "<leader>to", "<cmd>tabnew<CR>", desc = "Open new tab" },
    { "<leader>tx", "<cmd>tabclose<CR>", desc = "Close current tab" },
    { "<leader>tn", "<cmd>tabn<CR>", desc = "Go to next tab" },
    { "<leader>tp", "<cmd>tabp<CR>", desc = "Go to previous tab" },
    { "<leader>tf", "<cmd>tabnew %<CR>", desc = "Open current tab in new tab" },

    -- window / pane navigation
    { "<leader>h", "<C-w>h", desc = "Move to left pane" },
    { "<leader>j", "<C-w>j", desc = "Move to pane below" },
    { "<leader>k", "<C-w>k", desc = "Move to pane above" },
    { "<leader>l", "<C-w>l", desc = "Move to right pane" },
    { "<leader>h", "<C-\\><C-n><C-w>h", mode = "t", desc = "Move to left pane" },
    { "<leader>j", "<C-\\><C-n><C-w>j", mode = "t", desc = "Move to pane below" },
    { "<leader>k", "<C-\\><C-n><C-w>k", mode = "t", desc = "Move to pane above" },
    { "<leader>l", "<C-\\><C-n><C-w>l", mode = "t", desc = "Move to right pane" },
    { "<leader>sv", "<C-w>v", desc = "Split window vertically" },
    { "<leader>sh", "<C-w>s", desc = "Split window horizontally" },
    { "<leader>se", "<C-w>=", desc = "Make splits equal size" },
    { "<leader>sx", "<cmd>close<CR>", desc = "Close current split" },

    -- buffers
    { "<leader>bn", "<cmd>bnext<CR>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>bprevious<CR>", desc = "Previous buffer" },
    { "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete buffer" },
    { "<leader>1", "<cmd>1b<CR>", desc = "Switch to buffer 1" },
    { "<leader>2", "<cmd>2b<CR>", desc = "Switch to buffer 2" },
    { "<leader>3", "<cmd>3b<CR>", desc = "Switch to buffer 3" },
    { "<leader>4", "<cmd>4b<CR>", desc = "Switch to buffer 4" },
    { "<leader>5", "<cmd>5b<CR>", desc = "Switch to buffer 5" },
    { "<leader>6", "<cmd>6b<CR>", desc = "Switch to buffer 6" },
    { "<leader>7", "<cmd>7b<CR>", desc = "Switch to buffer 7" },
    { "<leader>8", "<cmd>8b<CR>", desc = "Switch to buffer 8" },
    { "<leader>9", "<cmd>9b<CR>", desc = "Switch to buffer 9" },

    -- misc
    { "<leader>fp", function()
        local filePath = vim.fn.expand("%:~")
        vim.fn.setreg("+", filePath)
        print("File path copied to clipboard: " .. filePath)
    end, desc = "Copy file path to clipboard" },
    { "<leader>re", "<cmd>restart<cr>", desc = "Restart Neovim (:restart)" },
    { "<leader>lr", function()
        vim.cmd("lsp restart")
        vim.notify("LSP restarted", vim.log.levels.INFO)
    end, desc = "Restart LSP" },
    { "<leader>u", function()
        vim.cmd.packadd("nvim.undotree")
        require("undotree").open()
    end, desc = "Toggle Builtin Undotree" },

    -- telescope
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Document Diagnostics" },
    { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "LSP Document Symbols" },
    { "<leader>fS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>fe", function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" then
            path = vim.uv.cwd()
        end
        local dir = vim.fn.fnamemodify(path, ":h")
        vim.cmd(("Neotree toggle %s"):format(vim.fn.fnameescape(dir)))
    end, desc = "File Explorer" },

    -- git
    { "<leader>gg", function()
        local file = vim.api.nvim_buf_get_name(0)
        local dir = (file ~= "" and vim.fs.dirname(file)) or vim.loop.cwd()
        local toplevel = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }))
        if vim.v.shell_error == 0 then
            require("neogit").open({ cwd = toplevel })
        else
            require("neogit").open()
        end
    end, desc = "Open Neogit (current git project)" },
    { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy git remote link" },
    { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git remote link in browser" },

    -- dap
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").list_breakpoints() vim.cmd("copen") end, desc = "List Breakpoints" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>dA", select_dap_config, desc = "Select DAP Configuration" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dapui").float_element("repl", { enter = true }) end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dv", function() require("dapui").float_element("scopes", { enter = true }) end, desc = "DAP Scopes / Variables" },
    { "<leader>dT", function() require("dapui").float_element("stacks", { enter = true }) end, desc = "DAP Threads / Call Stack" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dh", function() require("dapui").eval() end, desc = "DAP Hover" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "DAP View Toggle" },
    { "<leader>dw", function() require("dapui").eval() end, mode = "x", desc = "DAP Watch Selection" },

    -- lsp / diagnostics
    { "df", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
    { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line Diagnostics" },
    { "<leader>cD", "<cmd>Lspsaga show_buf_diagnostics<cr>", desc = "Buffer Diagnostics" },
    { "<leader>cw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", diagnostic_goto(true, vim.diagnostic.severity.ERROR), desc = "Next Error" },
    { "[e", diagnostic_goto(false, vim.diagnostic.severity.ERROR), desc = "Prev Error" },
    { "]w", diagnostic_goto(true, vim.diagnostic.severity.WARN), desc = "Next Warning" },
    { "[w", diagnostic_goto(false, vim.diagnostic.severity.WARN), desc = "Prev Warning" },
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },

    -- folds
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },

    -- trouble
    { "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>xD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / References (Trouble)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },

    -- neotest
    { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
    { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>To", function() require("neotest").output_panel.toggle() end, desc = "Toggle test output panel" },

    -- cmake / clangd
    { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
    { "<leader>cb", "<cmd>wa<cr><cmd>CMakeBuild<cr>", desc = "CMake Build" },
    { "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake Select Build Target" },
    { "<leader>cT", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake Select Launch Target" },
    { "<leader>cX", "<cmd>wa<cr><cmd>CMakeRun<cr>", desc = "CMake Run" },
    { "<leader>cG", "<cmd>wa<cr><cmd>CMakeDebug<cr>", desc = "CMake Debug" },
    { "<leader>cs", "<cmd>CMakeStopExecutor<cr>", desc = "CMake Stop Executor" },
    { "<leader>cS", "<cmd>CMakeStopRunner<cr>", desc = "CMake Stop Runner" },

    -- harpoon
    { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon: Add file" },
    { "<leader>he", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Quick menu" },
    { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon: Previous mark" },
    { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon: Next mark" },
    { "<leader>hrc", function() require("harpoon"):list():remove() end, desc = "Harpoon: Remove current buffer" },

    -- spectre
    { "<leader>so", function() require("spectre").open() end, desc = "Spectre: Open search & replace" },
    { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Spectre: Search current word" },
    { "<leader>sw", function() require("spectre").open_visual() end, mode = "v", desc = "Spectre: Search selection" },
    { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Spectre: Search in current file" },

    -- misc plugin maps
    { "<leader>Ag", function() require("neogen").generate() end, desc = "Generate Documentation (Neogen)" },
    { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
    { "<leader>mp", function()
        if mdserve_job then
            vim.fn.jobstop(mdserve_job)
        end
        local file = vim.fn.expand("%:p")
        if file == "" then
            vim.notify("No file to preview", vim.log.levels.WARN)
            return
        end
        mdserve_job = vim.fn.jobstart({ "mdserve", file, "--port", "1337", "--open" }, { detach = true })
    end, desc = "Markdown preview (mdserve)" },

    -- leap
    { "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward" },
    { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward" },
    { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
}

-- harpoon numbered marks
for i = 1, 9 do
    table.insert(spec, { "<leader>h" .. i, function()
        require("harpoon"):list():select(i)
    end, desc = "Harpoon: Select mark " .. i })
    table.insert(spec, { "<leader>hr" .. i, function()
        require("harpoon"):list():remove_at(i)
    end, desc = "Harpoon: Remove mark " .. i })
end

-- treesitter textobjects (only if plugin is available)
local ok_ts_to = pcall(require, "nvim-treesitter-textobjects")
if ok_ts_to then
    local select_maps = {
        ["af"] = "@function.outer", ["if"] = "@function.inner",
        ["ac"] = "@class.outer", ["ic"] = "@class.inner",
        ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer", ["il"] = "@loop.inner",
        ["ap"] = "@parameter.outer", ["ip"] = "@parameter.inner",
        ["ab"] = "@block.outer", ["ib"] = "@block.inner",
        ["ar"] = "@return.outer", ["ir"] = "@return.inner",
        ["ak"] = "@comment.outer", ["ik"] = "@comment.inner",
    }
    for key, query in pairs(select_maps) do
        table.insert(spec, { key, function()
            require("nvim-treesitter-textobjects.select").select_textobject(query)
        end, mode = { "x", "o" }, desc = "TS: " .. query })
    end

    local move_maps = {
        goto_next_start = {
            ["]a"] = "@assignment.outer", ["]f"] = "@function.outer", ["]c"] = "@class.outer",
            ["]k"] = "@comment.outer", ["]i"] = "@conditional.outer", ["]l"] = "@loop.outer",
            ["]b"] = "@block.outer", ["]p"] = "@parameter.outer",
        },
        goto_next_end = {
            ["]A"] = "@assignment.outer", ["]F"] = "@function.outer", ["]C"] = "@class.outer",
            ["]K"] = "@comment.outer", ["]I"] = "@conditional.outer", ["]L"] = "@loop.outer",
            ["]B"] = "@block.outer", ["]P"] = "@parameter.outer",
        },
        goto_previous_start = {
            ["[a"] = "@assignment.outer", ["[f"] = "@function.outer", ["[c"] = "@class.outer",
            ["[k"] = "@comment.outer", ["[i"] = "@conditional.outer", ["[l"] = "@loop.outer",
            ["[b"] = "@block.outer", ["[p"] = "@parameter.outer",
        },
        goto_previous_end = {
            ["[A"] = "@assignment.outer", ["[F"] = "@function.outer", ["[C"] = "@class.outer",
            ["[K"] = "@comment.outer", ["[I"] = "@conditional.outer", ["[L"] = "@loop.outer",
            ["[B"] = "@block.outer", ["[P"] = "@parameter.outer",
        },
    }
    for fn_name, mappings in pairs(move_maps) do
        for key, query in pairs(mappings) do
            table.insert(spec, { key, function()
                require("nvim-treesitter-textobjects.move")[fn_name](query)
            end, mode = { "n", "x", "o" }, desc = "TS: " .. fn_name .. " " .. query })
        end
    end
end

wk.add(spec)
