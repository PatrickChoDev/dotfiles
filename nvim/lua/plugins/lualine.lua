return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local filetype_names = {
      TelescopePrompt = 'Telescope',
      ['neo-tree'] = '',
      ['neo-tree-popup'] = 'NeoTree',
      ['fugitive'] = 'Git',
      ['fugitiveblame'] = 'Blame',
      ['packer'] = 'Packer',
      ['netrw'] = 'netrw',
      ['toggleterm'] = 'Terminal',
    }

    local mode = {
      'mode',
      fmt = function(str)
        return ' ' .. str
        -- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
      end,
    }

    local buffers = {
      'buffers',
      symbols = { modified = '● ', alternate_file = '#' },
      mode = 2,
      max_length = vim.o.columns * 2 / 3,
      filetype_names = filetype_names,
      buffers_color = {
        active = 'LualineBufferActive',
        inactive = 'LualineBufferInactive',
      },
    }

    local filename = {
      'filename',
      file_status = true,
      path = 1,
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
      cond = hide_in_width,
    }

    local windows = {
      'windows',
      show_filename_only = true,
      mode = 2,
      max_length = vim.o.columns / 3,
      filetype_names = filetype_names,
    }

    local tabs = {
      'tabs',
      mode = 0,
      max_length = vim.o.columns / 3,
      filetype_names = filetype_names,
    }

    local session = function()
      local resession = require 'resession'
      local current = resession.get_current()
      if current then
        return '󰆔'
      end
      return ''
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'alpha', 'neo-tree' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch' },
        lualine_c = { buffers },
        lualine_x = {
          { 'filetype', cond = hide_in_width },
        },
        lualine_y = { 'location', 'progress' },
        lualine_z = { 'lsp_status', session },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { windows },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { tabs },
      },
      inactive_tabline = {
        lualine_a = { windows },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { tabs },
      },
      winbar = {
        lualine_a = { filename },
        lualine_b = {},
        lualine_c = {},
        lualine_x = { diff },
        lualine_y = { diagnostics },
        lualine_z = { { 'location', padding = 0, 'progress' } },
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = { filename },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'fugitive' },
    }
  end,
}
