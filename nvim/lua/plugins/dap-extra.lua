-- Extra DAP adapters/configurations (Node + Python) layered on top of
-- LazyVim's `lazyvim.plugins.extras.dap.core` extra.
--
-- This file does NOT define any keymaps. All dap keymaps
-- (<leader>db, dc, dC, dg, di, dj, dk, dl, do, dO, dP, dr, ds, dt, dw, du, de, ...)
-- remain exactly as defined by LazyVim's dap.core extra.
--
-- It only registers:
--   1. The pwa-node / node / debugpy adapters.
--   2. Extra `dap.configurations` entries for js/ts and python, which show
--      up automatically in the core keymaps that use dap.configurations
--      (e.g. `require("dap").continue()` prompts you to pick one when
--      there's no active session).

return {
  {
    "mfussenegger/nvim-dap",
    -- Use `init` (runs before the plugin loads) so we don't clobber the
    -- `config` function LazyVim's dap.core extra already defines for this
    -- same plugin. `init` functions from multiple specs all run.
    init = function()
      local configured = false

      local function setup_extra_dap()
        if configured then
          return
        end
        configured = true

        local dap = require("dap")

        ---------------------------------------------------------------
        -- Node / JS / TS
        ---------------------------------------------------------------
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

        local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
        for _, ft in ipairs(js_filetypes) do
          dap.configurations[ft] = dap.configurations[ft] or {}
          vim.list_extend(dap.configurations[ft], {
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
          })
        end

        ---------------------------------------------------------------
        -- Python
        ---------------------------------------------------------------
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
            command = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/scripts/.venv/bin/python",
            args = { "-m", "debugpy.adapter" },
          })
        end

        local function ckan_project_root()
          local bufname = vim.api.nvim_buf_get_name(0)
          return (bufname ~= "" and vim.fs.root(bufname, "docker-compose.dev.yml")) or vim.fn.getcwd()
        end

        dap.configurations.python = dap.configurations.python or {}
        vim.list_extend(dap.configurations.python, {
          {
            type = "debugpy",
            request = "launch",
            name = "Launch calcularPeso.py",
            program = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/scripts/calcularPeso.py",
            pythonPath = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/scripts/.venv/bin/python",
            args = {
              "RAD",
              "2023-04-15T20:20:00.000000-0500",
              "2023-04-15T20:59:00.000000-0500",
              "4",
            },
            env = {
              DATA_HOME = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/data",
            },
            cwd = "/home/igp-otidgx/Projects/climadata/climadata-backend",
            justMyCode = true,
            redirectOutput = true,
            console = "integratedTerminal",
          },
          {
            type = "debugpy",
            request = "launch",
            name = "Launch crearZip.py",
            program = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/scripts/crearZip.py",
            pythonPath = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/scripts/.venv/bin/python",
            args = {
              "RAD",
              "RAD_220315_220317",
              "Reflectivity SNRg;Doppler Velocity VELg;Peak Width RMSg",
              "2023-04-15T20:00:00.000000-0500",
              "2023-04-15T20:20:00.000000-0500",
            },
            env = {
              DATA_HOME = "/home/igp-otidgx/Projects/climadata/climadata-backend/backend/data",
            },
            cwd = "/home/igp-otidgx/Projects/climadata/climadata-backend",
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
        })
      end

      -- Make sure adapters/configs are registered before dap is actually
      -- used, regardless of which core keymap triggers loading.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python", "typescript", "javascript", "typescriptreact", "javascriptreact" },
        callback = setup_extra_dap,
      })
    end,
  },
}
