-- Buffer-related keymaps

local M = {}
local opts = { noremap = true, silent = true }

function M.setup()
  local buffer_utils = require 'core.utils.buffer'

  -- Buffer navigation
  vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
  vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
  vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true, desc = '[B]uffer [N]ext' })
  vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true, desc = '[B]uffer [P]revious' })

  -- Buffer operations
  vim.keymap.set('n', '<leader>bc', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = '[B]uffer [C]lose' })
  vim.keymap.set('n', '<leader>bx', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = '[B]uffer [X] (close)' })
  vim.keymap.set('n', '<leader>bd', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = '[B]uffer [D]elete' })
  vim.keymap.set('n', '<leader>bN', '<cmd>enew<CR>', { noremap = true, silent = true, desc = '[B]uffer [N]ew' })

  -- Legacy keymaps for backward compatibility
  vim.keymap.set('n', '<leader>x', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = 'Close buffer' })
  vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', opts)
end

return M
