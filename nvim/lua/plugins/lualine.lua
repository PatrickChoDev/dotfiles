local smooth_buffers = require 'core.statusline.buffers'
smooth_buffers.setup()

local filetype_names = {
  TelescopePrompt = 'Telescope',
  ['neo-tree'] = '',
  ['neo-tree-popup'] = 'NeoTree',
  ['fugitive'] = 'Git',
  ['fugitiveblame'] = 'Blame',
  ['netrw'] = 'netrw',
}

local mode = {
  'mode',
  fmt = function(str)
    return ' ' .. str
  end,
}

local hide_in_width = function()
  return vim.fn.winwidth(0) > 100
end

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  sections = { 'error', 'warn' },
  symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
  colored = false,
  update_in_insert = false,
  always_visible = false,
  cond = hide_in_width,
}

local diff = {
  'diff',
  colored = true,
  symbols = { added = ' ', modified = ' ', removed = ' ' },
  cond = hide_in_width,
}

local filename = {
  'filename',
  file_status = true,
  path = 1,
}

local session_name = {
  function()
    local ok, resession = pcall(require, 'resession')
    if not ok then return '' end
    local name = resession.get_current()
    return name and (' ' .. name) or ''
  end,
}

local terminal_indicator = {
  function()
    local count = require('core.terminal').count 'vertical'
    return string.format(' %d', count)
  end,
  cond = function()
    return require('core.terminal').count 'vertical' > 0
  end,
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin-nvim',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha', 'neo-tree', 'TelescopePrompt', 'mason', 'notify', 'fugitive', 'fugitiveblame' },
      winbar = { 'alpha', 'neo-tree', 'TelescopePrompt', 'mason', 'notify', 'fugitive', 'fugitiveblame', 'dap-repl', 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes', 'dapui_console' },
    },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { 'branch' },
    lualine_c = {},
    lualine_x = {
      { 'filetype', cond = hide_in_width },
      terminal_indicator,
    },
    lualine_y = { session_name },
    lualine_z = { 'lsp_status' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = { terminal_indicator },
    lualine_y = { session_name },
    lualine_z = {},
  },
  -- Tabline removed: use tmux tabs / native neovim tabs instead
  tabline = {},
  winbar = {
    lualine_a = {
      {
        'filename',
        file_status = true,
        path = 1,
        -- Only show winbar for non-floating windows
        cond = function()
          return vim.api.nvim_win_get_config(0).relative == ''
        end,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = { diff },
    lualine_y = { diagnostics },
    lualine_z = { { 'location', padding = 0 }, 'progress' },
  },
  inactive_winbar = {
    lualine_a = {
      {
        'filename',
        file_status = true,
        path = 1,
        cond = function()
          return vim.api.nvim_win_get_config(0).relative == ''
        end,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'fugitive', 'neo-tree', 'nvim-dap-ui', 'quickfix', 'fzf', 'mason' },
}

-- Re-assert global statusline after lualine setup (prevents drift on resize)
vim.schedule(function()
  vim.o.laststatus = 3
  vim.o.showtabline = 0 -- tabline removed; tmux handles tabs
end)
