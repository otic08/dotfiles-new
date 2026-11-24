require("org").setup({
    org_directory = "~/gibs-manager/",
    agenda_files = { "~/gibs-manager/PNAIG/**/*.org" },
    default_notes_file = "~/gibs-manager/refile.org",
    export = {
        preview = {
            stylesheet = "~/.config/nvim/org-preview.css",
        },
    },
    extensions = {
        src_lsp = { languages = { "python", "lua"} },
    },
})
