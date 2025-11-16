-- Buffer utility functions

local M = {}
local nav_history = require 'core.utils.nav_history'

local function buffers_in_other_windows()
  local buffers = {}
  local current_win = vim.api.nvim_get_current_win()

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= current_win and vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if nav_history.is_regular_buffer(buf) then
        buffers[buf] = true
      end
    end
  end

  return buffers
end

-- Helper function to check if only neo-tree window remains
function M.is_only_neotree_window()
  local windows = vim.api.nvim_list_wins()
  local editor_windows = 0

  for _, win in ipairs(windows) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local filetype = vim.bo[bufnr].filetype
    -- Count non-neo-tree windows
    if filetype ~= 'neo-tree' and filetype ~= 'neo-tree-popup' then
      editor_windows = editor_windows + 1
    end
  end

  return editor_windows <= 1
end

-- Prompt to save unsaved changes
function M.prompt_save_changes(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not vim.bo[bufnr].modified then
    return true -- No changes, continue
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(filename, ':t')
  if short_name == '' then
    short_name = '[No Name]'
  end

  local choice = vim.fn.confirm('Save changes to "' .. short_name .. '"?', '&Yes\n&No\n&Cancel', 1)

  if choice == 1 then
    -- Save - if unnamed buffer, prompt for filename
    if filename == '' then
      local save_name = vim.fn.input('Save as: ', '', 'file')
      if save_name ~= '' then
        vim.cmd('write ' .. vim.fn.fnameescape(save_name))
        return true
      else
        return false -- User cancelled save
      end
    else
      vim.cmd 'write'
      return true
    end
  elseif choice == 3 or choice == 0 then
    return false -- Cancel or ESC
  end

  return true -- No (choice == 2), continue without saving
end

-- Smart buffer close (switch to next buffer if closing last editor window)
function M.smart_close_buffer()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Check if buffer has unsaved changes
  if not M.prompt_save_changes(current_buf) then
    return
  end

  -- Count total buffers
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  local total_buffers = #buffers

  -- If this is the last editor window (only neo-tree left), switch to next buffer then delete the old one
  if M.is_only_neotree_window() then
    local switched = nav_history.switch_to_previous_buffer(current_buf)

    if not switched then
      if total_buffers <= 1 then
        vim.cmd 'enew'
        switched = true
      else
        switched = M.goto_previous_buffer()
        if not switched then
          vim.cmd 'bnext'
          switched = vim.api.nvim_get_current_buf() ~= current_buf
        end
      end
    end

    if switched and vim.api.nvim_buf_is_valid(current_buf) and current_buf ~= vim.api.nvim_get_current_buf() then
      vim.cmd('bdelete! ' .. current_buf)
    end
  else
    -- If only one buffer, create new before deleting
    if total_buffers <= 1 then
      vim.cmd 'enew'
      if vim.api.nvim_buf_is_valid(current_buf) and current_buf ~= vim.api.nvim_get_current_buf() then
        vim.cmd('bdelete! ' .. current_buf)
      elseif vim.api.nvim_buf_is_valid(current_buf) then
        vim.cmd('bdelete! ' .. current_buf)
      end
      return
    end

    local switched = nav_history.switch_to_previous_buffer(current_buf)
    if not switched then
      switched = M.goto_previous_buffer()
      if not switched then
        vim.cmd 'bnext'
        switched = vim.api.nvim_get_current_buf() ~= current_buf
      end
    end

    if switched and vim.api.nvim_buf_is_valid(current_buf) and current_buf ~= vim.api.nvim_get_current_buf() then
      vim.cmd('bdelete! ' .. current_buf)
    end
  end
end

-- Switch to the previously used regular buffer (skips auxiliary buffers)
function M.goto_previous_buffer()
  if nav_history.switch_to_previous_buffer() then
    return true
  end

  local alt = vim.fn.bufnr '#'
  if alt ~= -1 and vim.fn.buflisted(alt) == 1 then
    vim.cmd 'buffer #'
    return true
  end

  return false
end

local function cycle_buffer(direction, opts)
  opts = opts or {}
  local skip_visible = opts.skip_visible ~= false
  local buffers = vim.fn.getbufinfo { buflisted = 1 }

  if #buffers <= 1 then
    return
  end

  local skip_set = skip_visible and buffers_in_other_windows() or {}
  local start_buf = vim.api.nvim_get_current_buf()

  local function move_once()
    if direction == 'previous' then
      vim.cmd 'bprevious'
    else
      vim.cmd 'bnext'
    end
  end

  for _ = 1, #buffers do
    move_once()
    local current = vim.api.nvim_get_current_buf()
    if current == start_buf or not skip_set[current] then
      break
    end
  end
end

function M.next_buffer(opts)
  cycle_buffer('next', opts)
end

function M.previous_buffer(opts)
  cycle_buffer('previous', opts)
end

return M
