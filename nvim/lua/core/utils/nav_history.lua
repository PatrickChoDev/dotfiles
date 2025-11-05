-- Shared navigation history for windows and buffers
-- Tracks recently focused regular windows and buffers so other utils can make smarter decisions.

local M = {}

local state = {
  window_history = {},
  buffer_history = {},
}

local MAX_HISTORY = 10

local function is_valid_window(win)
  if not win or win == 0 or not vim.api.nvim_win_is_valid(win) then
    return false
  end

  if vim.api.nvim_win_get_tabpage(win) ~= vim.api.nvim_get_current_tabpage() then
    return false
  end

  local config = vim.api.nvim_win_get_config(win)
  if config.relative and config.relative ~= '' then
    return false
  end

  local bufnr = vim.api.nvim_win_get_buf(win)
  return M.is_regular_buffer(bufnr)
end

local function push_unique(history, value)
  for idx, existing in ipairs(history) do
    if existing == value then
      table.remove(history, idx)
      break
    end
  end

  table.insert(history, 1, value)

  while #history > MAX_HISTORY do
    table.remove(history)
  end
end

local function remove_from_history(history, target)
  for idx = #history, 1, -1 do
    if history[idx] == target then
      table.remove(history, idx)
    end
  end
end

---@param bufnr integer
function M.is_regular_buffer(bufnr)
  if not bufnr or bufnr == 0 or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  local bo = vim.bo[bufnr]
  local ignored_filetypes = {
    ['neo-tree'] = true,
    ['neo-tree-popup'] = true,
  }

  if ignored_filetypes[bo.filetype] then
    return false
  end

  local allowed_buftypes = {
    [''] = true,
    terminal = true,
    acwrite = true,
  }

  return allowed_buftypes[bo.buftype] or false
end

---@param win integer
function M.is_regular_window(win)
  return is_valid_window(win)
end

local function record_window(win)
  if is_valid_window(win) then
    push_unique(state.window_history, win)

    local current_buf = vim.api.nvim_win_get_buf(win)
    if M.is_regular_buffer(current_buf) then
      push_unique(state.buffer_history, current_buf)
    end
  end
end

local function record_buffer(bufnr)
  if M.is_regular_buffer(bufnr) then
    push_unique(state.buffer_history, bufnr)

    local current_win = vim.fn.bufwinid(bufnr)
    if current_win ~= -1 then
      record_window(current_win)
    end
  end
end

local augroup = vim.api.nvim_create_augroup('CoreNavHistory', { clear = true })

vim.api.nvim_create_autocmd(
  { 'WinEnter', 'WinNew', 'BufWinEnter', 'TabEnter', 'TermEnter' },
  {
    group = augroup,
    callback = function(event)
      local win = event.win or vim.api.nvim_get_current_win()
      record_window(win)
    end,
  }
)

vim.api.nvim_create_autocmd(
  { 'BufEnter', 'BufAdd', 'TermOpen' },
  {
    group = augroup,
    callback = function(event)
      record_buffer(event.buf)
    end,
  }
)

vim.api.nvim_create_autocmd(
  { 'BufDelete', 'BufWipeout' },
  {
    group = augroup,
    callback = function(event)
      remove_from_history(state.buffer_history, event.buf)
    end,
  }
)

vim.api.nvim_create_autocmd(
  'WinClosed',
  {
    group = augroup,
    callback = function(event)
      local closed_win = tonumber(event.match)
      if closed_win then
        remove_from_history(state.window_history, closed_win)
      end
    end,
  }
)

local function iter_history(history, opts)
  opts = opts or {}
  local current = opts.current
  for _, value in ipairs(history) do
    if value ~= current then
      local validator = opts.validator
      if not validator or validator(value) then
        return value
      end
    end
  end
end

function M.previous_window()
  local current = vim.api.nvim_get_current_win()
  local win = iter_history(state.window_history, {
    current = current,
    validator = is_valid_window,
  })

  return win
end

function M.previous_buffer(reference_buf)
  local current = reference_buf or vim.api.nvim_get_current_buf()
  local buf = iter_history(state.buffer_history, {
    current = current,
    validator = M.is_regular_buffer,
  })

  return buf
end

function M.focus_previous_window()
  local win = M.previous_window()
  if win then
    vim.api.nvim_set_current_win(win)
    return true
  end
  return false
end

function M.focus_first_regular_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_valid_window(win) then
      vim.api.nvim_set_current_win(win)
      record_window(win)
      return true
    end
  end
  return false
end

function M.switch_to_previous_buffer(reference_buf)
  local buf = M.previous_buffer(reference_buf)
  if buf then
    vim.api.nvim_set_current_buf(buf)
    return true
  end
  return false
end

return M

