-- Window utility functions

local M = {}

-- Helper function to check if window is neo-tree
function M.is_neotree_window(winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local filetype = vim.bo[bufnr].filetype
  return filetype == 'neo-tree' or filetype == 'neo-tree-popup'
end

-- Get all regular windows (exclude neo-tree windows)
function M.get_regular_windows()
  local regular_windows = {}
  local windows = vim.api.nvim_list_wins()

  for _, win in ipairs(windows) do
    if not M.is_neotree_window(win) then
      table.insert(regular_windows, win)
    end
  end

  return regular_windows
end

-- Smart window close (prevent neo-tree glitch when closing last editor window)
function M.smart_close_window()
  local buffer_utils = require 'core.utils.buffer'
  local current_buf = vim.api.nvim_get_current_buf()

  -- Check if buffer has unsaved changes
  if not buffer_utils.prompt_save_changes(current_buf) then
    return
  end

  -- Count total buffers
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  local total_buffers = #buffers

  -- If this is the last editor window (only neo-tree left), switch buffer and delete the old one
  if buffer_utils.is_only_neotree_window() then
    -- If only one buffer, create a new empty buffer before deleting
    if total_buffers <= 1 then
      vim.cmd 'enew'
    else
      vim.cmd 'bnext'
    end
    -- Delete the previous buffer if it's valid and different from current
    if vim.api.nvim_buf_is_valid(current_buf) and current_buf ~= vim.api.nvim_get_current_buf() then
      vim.cmd('bdelete! ' .. current_buf)
    end
  else
    vim.cmd 'close'
  end
end

-- Smart window rotation (skip neo-tree)
function M.rotate_windows(direction)
  -- Don't rotate if current window is neo-tree
  if M.is_neotree_window() then
    vim.notify('Cannot rotate from neo-tree window', vim.log.levels.WARN)
    return
  end

  -- Get all regular windows (exclude neo-tree windows)
  local regular_windows = M.get_regular_windows()

  -- Need at least 2 regular windows to rotate
  if #regular_windows < 2 then
    vim.notify('Need at least 2 regular windows to rotate', vim.log.levels.WARN)
    return
  end

  -- Store current window positions and buffers for regular windows only
  local window_info = {}
  for i, win in ipairs(regular_windows) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local cursor = vim.api.nvim_win_get_cursor(win)
    window_info[i] = { bufnr = bufnr, cursor = cursor }
  end

  -- Rotate the buffer assignments
  if direction == 'clockwise' then
    -- Move each buffer to the next window (last buffer goes to first window)
    local last_info = window_info[#window_info]
    for i = #window_info, 2, -1 do
      vim.api.nvim_win_set_buf(regular_windows[i], window_info[i - 1].bufnr)
      vim.api.nvim_win_set_cursor(regular_windows[i], window_info[i - 1].cursor)
    end
    vim.api.nvim_win_set_buf(regular_windows[1], last_info.bufnr)
    vim.api.nvim_win_set_cursor(regular_windows[1], last_info.cursor)
  else
    -- Move each buffer to the previous window (first buffer goes to last window)
    local first_info = window_info[1]
    for i = 1, #window_info - 1 do
      vim.api.nvim_win_set_buf(regular_windows[i], window_info[i + 1].bufnr)
      vim.api.nvim_win_set_cursor(regular_windows[i], window_info[i + 1].cursor)
    end
    vim.api.nvim_win_set_buf(regular_windows[#regular_windows], first_info.bufnr)
    vim.api.nvim_win_set_cursor(regular_windows[#regular_windows], first_info.cursor)
  end
end

-- Smart swap function (prevent swapping with neo-tree)
function M.smart_swap_window()
  local current_win = vim.api.nvim_get_current_win()

  -- Don't swap if current window is neo-tree
  if M.is_neotree_window(current_win) then
    vim.notify('Cannot swap from neo-tree window', vim.log.levels.WARN)
    return
  end

  -- Get the window that would be swapped with
  local windows = vim.api.nvim_list_wins()
  local current_idx = nil

  for i, win in ipairs(windows) do
    if win == current_win then
      current_idx = i
      break
    end
  end

  if not current_idx then
    return
  end

  -- Find next window (wraps around)
  local next_idx = (current_idx % #windows) + 1
  local next_win = windows[next_idx]

  -- Check if next window is neo-tree
  if M.is_neotree_window(next_win) then
    vim.notify('Cannot swap with neo-tree window', vim.log.levels.WARN)
    return
  end

  -- Perform the swap
  vim.cmd 'wincmd x'
end

-- Equalize window sizes, preserving neo-tree width
function M.equalize_windows()
  -- Find neo-tree window
  local neotree_win = nil
  local windows = vim.api.nvim_list_wins()

  for _, win in ipairs(windows) do
    if M.is_neotree_window(win) then
      neotree_win = win
      break
    end
  end

  vim.cmd 'wincmd ='

  if neotree_win then
    -- Set neo-tree to default width (usually around 40 columns)
    vim.api.nvim_win_set_width(neotree_win, 40)
  end
end

return M
