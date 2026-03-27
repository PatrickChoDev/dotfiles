-- Window-related keymaps

local M = {}
local opts = { noremap = true, silent = true }

function M.setup()
  local window_utils = require 'core.utils.window'
  local terminal_utils = require 'core.terminal'

  -- Window splits
  vim.keymap.set('n', '<leader>wv', '<C-w>v', { noremap = true, silent = true, desc = '[W]indow split [V]ertical' })
  vim.keymap.set('n', '<leader>wh', '<C-w>s', { noremap = true, silent = true, desc = '[W]indow split [H]orizontal' })

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

  -- Terminal mode: exit to normal
  vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', opts)

  -- Terminal mode: navigate windows without leaving insert mode
  vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', opts)
  vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', opts)
  vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', opts)
  vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', opts)

  -- Quickly open terminals in splits
  vim.keymap.set('n', '<leader>tv', terminal_utils.open_terminal_vsplit, { noremap = true, silent = true, desc = '[T]erminal vertical split' })
  vim.keymap.set('n', '<leader>th', function()
    terminal_utils.open_terminal_hsplit { height_ratio = 0.3 }
  end, { noremap = true, silent = true, desc = '[T]erminal [H]orizontal split (30%)' })

  -- Toggle last hsplit terminal (open if hidden, hide if visible, create if none)
  vim.keymap.set('n', '<leader>tt', function()
    terminal_utils.toggle_terminal('horizontal', { height_ratio = 0.3 })
  end, { noremap = true, silent = true, desc = '[T]erminal [T]oggle' })

  -- Select terminal session via Telescope
  vim.keymap.set('n', '<leader>ts', terminal_utils.pick_terminal, { noremap = true, silent = true, desc = '[T]erminal [S]elect' })
end

return M
