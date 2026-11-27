require("org").setup({
    ui = {
       images = {
         startup = true, -- previsualizar imágenes al abrir el archivo
         -- backend = "auto", -- default: nvim 0.13+ kitty protocol / snacks / image.nvim
      },
    },
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
