local leader = vim.g.mapleader or '\\'
require('blink.cmp').setup({

    keymap = {
        [leader .. 'k'] = {"show", "hide"},
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'org' },
        providers = {
            org = { name = "Org", module = "org.completion.blink" },
        },
    },

    completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' }, auto_show = true, auto_show_delay_ms = 500 },
    },

	signature = {
		enabled = true,
		window = { border = 'single', show_documentation = true},
	},


    })


