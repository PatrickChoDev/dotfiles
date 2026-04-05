-- Window-related keymaps

local M = {}
local opts = { noremap = true, silent = true }

-- Smart directional navigation: try neovim window first, fall back to tmux pane.
local function navigate(direction)
  local tmux_dir = { h = 'L', j = 'D', k = 'U', l = 'R' }
  local prev_win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction)
  -- If we didn't move and we're inside tmux, pass the navigation to tmux
  if vim.api.nvim_get_current_win() == prev_win and vim.env.TMUX then
    vim.fn.system('tmux select-pane -' .. tmux_dir[direction])
  end
end

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

  -- Navigate between splits (Ctrl + hjkl) — falls back to tmux pane when at edge
  vim.keymap.set('n', '<C-k>', function() navigate 'k' end, opts)
  vim.keymap.set('n', '<C-j>', function() navigate 'j' end, opts)
  vim.keymap.set('n', '<C-h>', function() navigate 'h' end, opts)
  vim.keymap.set('n', '<C-l>', function() navigate 'l' end, opts)

  -- Terminal mode: exit to normal
  vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', opts)

  -- Terminal mode: navigate windows (exit terminal insert, then navigate with tmux fallback)
  local esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true)
  local function t_navigate(direction)
    return function()
      vim.api.nvim_feedkeys(esc, 'n', false)
      vim.schedule(function() navigate(direction) end)
    end
  end
  vim.keymap.set('t', '<C-h>', t_navigate 'h', opts)
  vim.keymap.set('t', '<C-j>', t_navigate 'j', opts)
  vim.keymap.set('t', '<C-k>', t_navigate 'k', opts)
  vim.keymap.set('t', '<C-l>', t_navigate 'l', opts)

  -- Terminal: open splits
  vim.keymap.set('n', '<leader>tv', terminal_utils.open_terminal_vsplit, { noremap = true, silent = true, desc = '[T]erminal [V]ertical split (tmux pane or vsplit)' })
  vim.keymap.set('n', '<leader>th', function()
    terminal_utils.open_terminal_hsplit { height_ratio = 0.3, height_pct = 30 }
  end, { noremap = true, silent = true, desc = '[T]erminal [H]orizontal split (tmux pane or split)' })

  -- Terminal: open in new tmux window (falls back to vsplit)
  vim.keymap.set('n', '<leader>tn', terminal_utils.open_terminal_window, { noremap = true, silent = true, desc = '[T]erminal [N]ew window (tmux window or vsplit)' })

  -- Terminal: toggle floating popup (tmux) or hsplit (built-in)
  vim.keymap.set('n', '<leader>tt', function()
    terminal_utils.toggle_terminal('horizontal', { height_ratio = 0.3, height_pct = 30 })
  end, { noremap = true, silent = true, desc = '[T]erminal [T]oggle (tmux popup or hsplit)' })

  -- Terminal: select session via Telescope (built-in terminals only)
  vim.keymap.set('n', '<leader>ts', terminal_utils.pick_terminal, { noremap = true, silent = true, desc = '[T]erminal [S]elect session' })
end

return M
