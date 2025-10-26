-- Tab-related keymaps

local M = {}
local opts = { noremap = true, silent = true }

function M.setup()
  local tab_utils = require 'core.utils.tab'

  -- Tab operations
  vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true, desc = '[T]ab [N]ew' })
  vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true, desc = '[T]ab [C]lose' })
  vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { noremap = true, silent = true, desc = '[T]ab [X] (close)' })

  -- Tab navigation
  vim.keymap.set('n', '<leader>t]', ':tabn<CR>', { noremap = true, silent = true, desc = '[T]ab ] (next)' })
  vim.keymap.set('n', '<leader>t[', ':tabp<CR>', { noremap = true, silent = true, desc = '[T]ab [ (previous)' })
  vim.keymap.set('n', ']t', ':tabn<CR>', { noremap = true, silent = true, desc = 'Tab next' })
  vim.keymap.set('n', '[t', ':tabp<CR>', { noremap = true, silent = true, desc = 'Tab previous' })

  -- Tab movement
  vim.keymap.set('n', '<leader>tm', tab_utils.move_tab_to_window, { noremap = true, silent = true, desc = '[T]ab [M]ove to window' })
  vim.keymap.set('n', '<leader>tM', tab_utils.move_tab_to_tab_number, { noremap = true, silent = true, desc = '[T]ab [M]ove to tab number' })
  vim.keymap.set('n', '<leader>tT', '<C-w>T', { noremap = true, silent = true, desc = '[T]ab break window to new [T]ab' })

  -- Legacy keymaps for backward compatibility
  vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)
end

return M
