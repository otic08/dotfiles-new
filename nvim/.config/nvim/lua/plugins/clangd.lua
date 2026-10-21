require("clangd_extensions").setup({
    inlay_hints = {
        inline = vim.fn.has("nvim-0.10") == 1,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
        priority = 100,
    },
    ast = {
        role_icons = {
            type = "🄣",
            declaration = "🄓",
            expression = "🄔",
            statement = ";",
            specifier = "🄢",
            ["template argument"] = "🆃",
        },
        kind_icons = {
            Compound = "🄲",
            Recovery = "🅁",
            TranslationUnit = "🅄",
            PackExpansion = "🄿",
            TemplateTypeParm = "🅃",
            TemplateTemplateParm = "🅃",
            TemplateParamObject = "🅃",
        },
        highlights = {
            detail = "Comment",
        },
    },
    memory_usage = {
        border = "none",
    },
    symbol_info = {
        border = "none",
    },
})

local osys = require("cmake-tools.osys")
require("cmake-tools").setup({
    cmake_command = "cmake",
    ctest_command = "ctest",
    cmake_regenerate_on_save = true,
    cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
    cmake_build_directory = function()
        if osys.iswin32 then
            return "build\\${variant:buildType}"
        end
        return "build/${variant:buildType}"
    end,
    cmake_soft_link_compile_commands = true,
    cmake_compile_commands_from_lsp = false,
    cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = false,
        console = "integratedTerminal",
    },
    cmake_executor = {
        name = "quickfix",
        opts = {
            show = "only_on_error",
            position = "belowright",
            size = 10,
        },
    },
    cmake_runner = {
        name = "terminal",
        opts = {
            split_direction = "horizontal",
            split_size = 11,
            focus = false,
        },
    },
    cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
    },
    cmake_virtual_text_support = false,
})

vim.keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
vim.keymap.set("n", "<leader>cb", "<cmd>wa<cr><cmd>CMakeBuild<cr>", { desc = "CMake Build" })
vim.keymap.set("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "CMake Select Build Target" })
vim.keymap.set("n", "<leader>cT", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "CMake Select Launch Target" })
vim.keymap.set("n", "<leader>cX", "<cmd>wa<cr><cmd>CMakeRun<cr>", { desc = "CMake Run" })
vim.keymap.set("n", "<leader>cG", "<cmd>wa<cr><cmd>CMakeDebug<cr>", { desc = "CMake Debug" })
vim.keymap.set("n", "<leader>cs", "<cmd>CMakeStopExecutor<cr>", { desc = "CMake Stop Executor" })
vim.keymap.set("n", "<leader>cS", "<cmd>CMakeStopRunner<cr>", { desc = "CMake Stop Runner" })
