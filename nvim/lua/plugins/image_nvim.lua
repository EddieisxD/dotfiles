
return {
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- or "ueberzug" if your terminal requires it
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true, -- Auto-fetches web URLs!
          only_render_image_at_cursor = false,
        },
      },
      max_width = 100,
      max_height = 12,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "noice" },
    },
  }
}
