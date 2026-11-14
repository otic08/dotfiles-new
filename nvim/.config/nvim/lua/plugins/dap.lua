local _dap_initialized = false

local function init_dap()
    if _dap_initialized then
        return
    end

    _dap_initialized = true

    local dap = require("dap")

    local js_debug_path = vim.fn.expand("$HOME/vscode-js-debug/dist/src/dapDebugServer.js")
    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = { js_debug_path, "${port}" },
        },
    }
    dap.adapters["node"] = function(cb, config)
        if config.type == "node" then
            config.type = "pwa-node"
        end
        local a = dap.adapters["pwa-node"]
        if type(a) == "function" then
            a(cb, config)
        else
            cb(a)
        end
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    dap.providers.configs["dap.launch.json"] = function()
        return {}
    end

    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
    for _, ft in ipairs(js_filetypes) do
        dap.configurations[ft] = {
            {
                type = "pwa-node",
                request = "attach",
                name = "Nvim Debug App",
                port = 9229,
                address = "localhost",
                localRoot = vim.fn.getcwd(),
                remoteRoot = "/usr/src/app",
                sourceMaps = true,
                protocol = "inspector",
                cwd = vim.fn.getcwd(),
            },
            {
                type = "pwa-node",
                request = "launch",
                name = "Nvim Mocha Tests",
                program = vim.fn.getcwd() .. "/node_modules/mocha/bin/_mocha",
                args = {
                    "--require",
                    "ts-node/register/transpile-only",
                    "--require",
                    "source-map-support/register",
                    "--reporter",
                    "spec",
                    "--colors",
                    vim.fn.getcwd() .. "/tests/unit/**/*.[tj]s",
                },
                internalConsoleOptions = "openOnSessionStart",
                skipFiles = { "<node_internals>/**" },
                sourceMaps = true,
                protocol = "inspector",
                cwd = vim.fn.getcwd(),
            },
        }
    end

    dap.adapters.debugpy = function(cb, config)
        if config.request == "attach" then
            local connect = config.connect or config
            cb({
                type = "server",
                host = connect.host or "127.0.0.1",
                port = assert(connect.port, "debugpy attach requires connect.port"),
            })
            return
        end

        cb({
            type = "executable",
            command = "~/IGP/climadata/climadata-backend/backend/scripts/.venv/bin/python",
            args = { "-m", "debugpy.adapter" },
        })
    end

    local function ckan_project_root()
        local bufname = vim.api.nvim_buf_get_name(0)
        return (bufname ~= "" and vim.fs.root(bufname, "docker-compose.dev.yml")) or vim.fn.getcwd()
    end

    dap.configurations.python = {
        {
            type = "debugpy",
            request = "launch",
            name = "Launch calcularPeso.py",
            program = "~/IGP/climadata/climadata-backend/backend/scripts/calcularPeso.py",
            pythonPath = "~/IGP/climadata/climadata-backend/backend/scripts/.venv/bin/python",
            args = {
                "RAD",
                "mensual",
                "2023-04-15T20:20:00.000000-0500",
                "2023-04-15T20:59:00.000000-0500",
                "4",
            },
            env = {
                DATA_HOME = "~/IGP/climadata/climadata-backend/backend/data",
            },
            cwd = "~/IGP/climadata/climadata-backend",
            redirectOutput = true,
            console = "integratedTerminal",
        },

        {
            type = "debugpy",
            request = "launch",
            name = "Launch crearZip.py",
            program = "scripts/crearZip.py",
            pythonPath = "~/IGP/climadata/climadata-backend/backend/scripts/.venv/bin/python",
            args = {
                "RAD",
                "RAD_220315_220317",
                "Reflectivity SNRg;Doppler Velocity VELg;Peak Width RMSg",
                "2023-04-15T20:00:00.000000-0500",
                "2023-04-15T20:20:00.000000-0500",
            },
            env = {
                DATA_HOME = "~/IGP/climadata/climadata-backend/backend/data",
            },
            cwd = "~/IGP/climadata/climadata-backend",
            justMyCode = true,
            redirectOutput = true,
            console = "integratedTerminal",
        },

        {
            type = "debugpy",
            request = "attach",
            name = "CKAN: Attach (debugpy)",
            connect = { host = "127.0.0.1", port = 5678 },
            pathMappings = function()
                local root = ckan_project_root()
                return {
                    { localRoot = root .. "/src", remoteRoot = "/srv/app/src_extensions" },
                    { localRoot = root .. "/ckan-core-ro", remoteRoot = "/srv/app/src/ckan" },
                }
            end,
            justMyCode = false,
            redirectOutput = true,
        },
        {
            type = "debugpy",
            request = "attach",
            name = "CKAN Worker: Attach (downloads, debugpy)",
            connect = { host = "127.0.0.1", port = 5679 },
            pathMappings = function()
                local root = ckan_project_root()
                return {
                    { localRoot = root .. "/src", remoteRoot = "/srv/app/src_extensions" },
                    { localRoot = root .. "/ckan-core-ro", remoteRoot = "/srv/app/src/ckan" },
                }
            end,
            justMyCode = false,
            redirectOutput = true,
        },
        {
            type = "debugpy",
            request = "attach",
            name = "CKAN Worker: Attach (scidata, debugpy)",
            connect = { host = "127.0.0.1", port = 5680 },
            pathMappings = function()
                local root = ckan_project_root()
                return {
                    { localRoot = root .. "/src", remoteRoot = "/srv/app/src_extensions" },
                    { localRoot = root .. "/ckan-core-ro", remoteRoot = "/srv/app/src/ckan" },
                }
            end,
            justMyCode = false,
            redirectOutput = true,
        },

    }

    local cpp_dap_executable = vim.fn.stdpath("data")
        .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"

    dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = cpp_dap_executable,
        enrich_config = function(config, on_config)
            local enriched = vim.deepcopy(config)
            enriched.MIMode = enriched.MIMode or (vim.fn.has("mac") == 1 and "lldb" or "gdb")
            if enriched.MIMode == "gdb" and not enriched.setupCommands then
                enriched.setupCommands = {
                    { text = "-enable-pretty-printing", ignoreFailures = true },
                }
            end
            on_config(enriched)
        end,
    }

    local codelldb_root = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = codelldb_root .. "adapter/codelldb"

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = codelldb_path,
            args = { "--port", "${port}" },
        },
    }

    require("dap.ext.vscode").type_to_filetypes = {
        cppdbg = { "c", "cpp" },
        codelldb = { "c", "cpp", "rust" },
    }

    for _, lang in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[lang] = {
            {
                name = "Launch file (codelldb)",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "Attach to process (codelldb)",
                type = "codelldb",
                request = "attach",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
        }
    end

    require("nvim-dap-virtual-text").setup()

    local dapui = require("dapui")
    dapui.setup({
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.4 },
                    { id = "watches", size = 0.2 },
                    { id = "breakpoints", size = 0.2 },
                    { id = "stacks", size = 0.2 },
                },
                size = 0.4,
                position = "right",
            },
            {
                elements = {
                    { id = "repl", size = 0.5 },
                    { id = "console", size = 0.5 },
                },
                size = 0.25,
                position = "bottom",
            },
        },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

init_dap()
