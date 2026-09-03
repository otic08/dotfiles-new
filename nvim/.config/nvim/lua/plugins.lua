vim.pack.add({
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/tpope/vim-fugitive",
    { src = "https://github.com/mfussenegger/nvim-dap", version = "b516f20b" },
    { src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
    "https://github.com/meanderingprogrammer/render-markdown.nvim",
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads})
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/karb94/neoscroll.nvim",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/snacks.nvim"
})

require("plugins.colorscheme")
require("plugins.mini")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.dap")
require("plugins.render-markdown")
require("plugins.neoscroll")
require("plugins.oil")
require("plugins.snacks")
    -- Blink.cmp
    require('blink.cmp').setup({

    completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' }, auto_show = true, auto_show_delay_ms = 500 },
    },

	signature = {
		enabled = true,
		window = { border = 'single', show_documentation = true},
	},
})

local function python_env()
  if vim.bo.filetype ~= "python" then
    return ""
  end

  local venv = vim.env.VIRTUAL_ENV
  local venv_name = venv and vim.fn.fnamemodify(venv, ":t") or nil

  local python = vim.g.python3_host_prog or vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
  local version = vim.fn.system(python .. " -V 2>&1"):gsub("Python ", ""):gsub("%s+", " "):gsub("^%s*", ""):gsub("%s*$", "")
  if version == "" or version:match("not found") or version:match("No such") then
    version = ""
  end

  if venv_name and version ~= "" then
    return venv_name .. " (" .. version .. ")"
  elseif venv_name then
    return venv_name
  elseif version ~= "" then
    return version
  end
  return ""
end

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_x = { python_env, 'encoding', 'fileformat', 'filetype' },
  }
}
