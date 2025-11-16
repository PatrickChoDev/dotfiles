return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      background = { -- :h background
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      auto_integrations = true,
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      highlight_overrides = {
        all = function(colors)
          return {
            Cursor = { fg = colors.base, bg = colors.text, style = { 'bold' } },
            lCursor = { fg = colors.base, bg = colors.text },
            TermCursor = { fg = colors.base, bg = colors.text },
            TermCursorNC = { fg = colors.text, bg = colors.surface0 },
            CursorLineNr = { fg = colors.text, style = { 'bold' } },
          }
        end,
      },
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
