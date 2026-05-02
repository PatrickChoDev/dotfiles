require('catppuccin').setup {
  background = {
    light = 'latte',
    dark = 'mocha',
  },
  transparent_background = false,
  auto_integrations = true,
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
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
vim.cmd.colorscheme 'catppuccin-nvim'

-- Auto-switch between latte (light) and mocha (dark) when macOS appearance changes.
require('auto-dark-mode').setup {
  set_dark_mode = function()
    vim.o.background = 'dark'
    vim.cmd.colorscheme 'catppuccin-nvim'
  end,
  set_light_mode = function()
    vim.o.background = 'light'
    vim.cmd.colorscheme 'catppuccin-nvim'
  end,
  update_interval = 3000, -- poll every 3 s
}
