-- Window-related keymaps

local M = {}
local opts = { noremap = true, silent = true }

function M.setup()
  local window_utils = require 'core.utils.window'

  -- Window splits
  vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
  vim.keymap.set('n', '<leader>wv', '<C-w>v', { noremap = true, silent = true, desc = '[W]indow split [V]ertical' })
  vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
  vim.keymap.set('n', '<leader>wh', '<C-w>s', { noremap = true, silent = true, desc = '[W]indow split [H]orizontal' })
  vim.keymap.set('n', '<leader>ws', '<C-w>s', { noremap = true, silent = true, desc = '[W]indow [S]plit horizontal' })

  -- Window management
  vim.keymap.set('n', '<leader>wc', window_utils.smart_close_window, { noremap = true, silent = true, desc = '[W]indow [C]lose' })
  vim.keymap.set('n', '<leader>we', window_utils.equalize_windows, { noremap = true, silent = true, desc = '[W]indow [E]qualize' })
  vim.keymap.set('n', '<leader>w=', window_utils.equalize_windows, { noremap = true, silent = true, desc = '[W]indow = (equalize)' })

  -- Window swapping and rotation
  vim.keymap.set('n', '<leader>wS', window_utils.smart_swap_window, { noremap = true, silent = true, desc = '[W]indow [S]wap' })
  vim.keymap.set('n', '<leader>wr', function()
    window_utils.rotate_windows 'clockwise'
  end, { noremap = true, silent = true, desc = '[W]indow [R]otate clockwise' })
  vim.keymap.set('n', '<leader>wR', function()
    window_utils.rotate_windows 'counter-clockwise'
  end, { noremap = true, silent = true, desc = '[W]indow [R]otate counter-clockwise' })

  vim.keymap.set('n', '<leader>wm', window_utils.winshift_move_mode, { noremap = true, silent = true, desc = '[W]indow [M]ove mode' })

  -- Window navigation
  vim.keymap.set('n', '<leader>wp', function()
    window_utils.focus_previous_regular_window()
  end, { noremap = true, silent = true, desc = '[W]indow [P]revious' })
  vim.keymap.set('n', '<C-w><C-p>', function()
    window_utils.focus_previous_regular_window()
  end, opts)

  -- Navigate between splits (Ctrl + hjkl)
  vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
  vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
  vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
  vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

  -- Terminal mode
  vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', opts)
end

return M
