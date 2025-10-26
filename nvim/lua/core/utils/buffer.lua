-- Buffer utility functions

local M = {}

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
    -- If only one buffer, create new before deleting
    if total_buffers <= 1 then
      vim.cmd 'enew'
      vim.cmd('bdelete! ' .. current_buf)
    else
      vim.cmd 'bdelete!'
    end
  end
end

return M
