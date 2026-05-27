-- Buffer-related keymaps

local M = {}
local opts = { noremap = true, silent = true }

function M.setup()
  local buffer_utils = require 'core.utils.buffer'
  local function is_terminal_buffer()
    return vim.bo.buftype == 'terminal'
  end

  local function guarded(fn)
    return function()
      if is_terminal_buffer() then
        return
      end
      fn()
    end
  end

  -- Buffer navigation
  vim.keymap.set('n', '<Tab>', guarded(function()
    buffer_utils.next_buffer { skip_visible = true, skip_terminal = true }
  end), { noremap = true, silent = true, desc = 'Next buffer (skip visible)' })
  vim.keymap.set('n', '<S-Tab>', guarded(function()
    buffer_utils.previous_buffer { skip_visible = true, skip_terminal = true }
  end), { noremap = true, silent = true, desc = 'Previous buffer (skip visible)' })
  vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true, desc = '[B]uffer [N]ext' })
  vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true, desc = '[B]uffer [P]revious' })
  vim.keymap.set('n', '<leader>bb', buffer_utils.goto_previous_buffer, { noremap = true, silent = true, desc = '[B]uffer [B]ack (recent)' })

  -- Buffer operations
  vim.keymap.set('n', '<leader>x', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = 'Close buffer' })
  vim.keymap.set('n', '<leader>bx', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = '[B]uffer [X] (close)' })
  vim.keymap.set('n', '<leader>bN', '<cmd>enew<CR>', { noremap = true, silent = true, desc = '[B]uffer [N]ew' })
  vim.keymap.set('n', '<leader>bca', buffer_utils.close_all_buffers, { noremap = true, silent = true, desc = '[B]uffer [C]lose [A]ll' })
  vim.keymap.set('n', '<leader>bco', buffer_utils.close_other_buffers, { noremap = true, silent = true, desc = '[B]uffer [C]lose [O]thers' })
  vim.keymap.set('n', '<leader>bcu', buffer_utils.close_unmodified_buffers, { noremap = true, silent = true, desc = '[B]uffer [C]lose [U]nmodified' })
end

return M
