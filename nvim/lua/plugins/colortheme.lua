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
