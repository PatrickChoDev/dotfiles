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
  vim.keymap.set('n', '<leader>bb', buffer_utils.goto_previous_buffer, { noremap = true, silent = true, desc = '[B]uffer [B]ack (recent)' })

  -- Buffer operations
  vim.keymap.set('n', '<leader>x', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = 'Close buffer' })
  vim.keymap.set('n', '<leader>bx', buffer_utils.smart_close_buffer, { noremap = true, silent = true, desc = '[B]uffer [X] (close)' })
  vim.keymap.set('n', '<leader>bN', '<cmd>enew<CR>', { noremap = true, silent = true, desc = '[B]uffer [N]ew' })
  vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', opts)
  vim.keymap.set('n', '<leader>br', vim.lsp.buf.rename, { noremap = true, silent = true, desc = '[B]uffer [R]ename' })
end

return M
