require('image').setup {
  backend = 'kitty', -- Ghostty implements the Kitty graphics protocol
  processor = 'magick_cli',
  integrations = {
    markdown = { enabled = true },
    neorg = { enabled = true },
    typst = { enabled = true },
    html = { enabled = false },
    css = { enabled = false },
  },
  max_height_window_percentage = 50,
  hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
}
