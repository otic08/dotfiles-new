require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  integrations = {
    markdown = {
      enabled = true,
      download_remote_images = true,
      only_render_image_at_cursor = false,
    },
  },
  max_height_window_percentage = 50,
})
