return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'Bdelete! %d',
        right_mouse_command = 'Bdelete! %d',
        left_mouse_command = 'buffer %d',

        buffer_close_icon = '󰅖',
        close_icon = '',
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',

        path_components = 2,
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 18,

        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icons = {
            error = '',
            warning = '',
            info = '',
            hint = '󰌵',
          }
          local colors = {
            error = '%#DiagnosticError#',
            warning = '%#DiagnosticWarn#',
            info = '%#DiagnosticInfo#',
            hint = '%#DiagnosticHint#',
          }

          local s = ''
          for severity, n in pairs(diagnostics_dict) do
            if n > 0 then
              local icon = icons[severity] or ''
              local color = colors[severity] or ''
              s = s .. color .. icon .. n .. ''
            end
          end

          -- Reset to default highlight group
          s = s .. '%#BufferLineBufferSelected#'
          return s
        end,

        offsets = {
          { filetype = 'neo-tree', text = 'File Explorer', text_align = 'center', separator = true },
          { filetype = 'oil', text = 'File Explorer', text_align = 'center', separator = true },
        },

        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        always_show_bufferline = false,

        persist_buffer_sort = true,
        separator_style = 'thin',
        enforce_regular_tabs = true,
        sort_by = 'insert_after_current',

        indicator = { style = 'none' },
        icon_pinned = '󰐃',
        minimum_padding = 2,
        maximum_padding = 4,
        maximum_length = 15,
      },

      highlights = (function()
        local bg = '#313244' -- Catppuccin Surface0
        return {
          buffer_selected = { bold = true, italic = false },
          tab_selected = { bold = true, italic = false },
        }
      end)(),
    }
  end,

  keys = {
    { '<leader>bb', '<cmd>BufferLinePick<cr>', desc = 'Pick buffer' },
    { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick and close buffer' },
    { '<leader>bh', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close all left buffers' },
    { '<leader>bl', '<cmd>BufferLineCloseRight<cr>', desc = 'Close all right buffers' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close other buffers' },
    { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Toggle pin buffer' },
    { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', desc = 'Close unpinned buffers' },
  },
}
