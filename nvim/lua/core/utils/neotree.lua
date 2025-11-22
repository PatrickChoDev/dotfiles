-- Helper utilities to coordinate Neo-tree and regular buffers/windows

local M = {}

local window_utils = require 'core.utils.window'

local refresh_pending = {
  filesystem = false,
  git_status = false,
}

local function get_state()
  local ok_manager, manager = pcall(require, 'neo-tree.sources.manager')
  if not ok_manager then
    return nil
  end

  return manager.get_state 'filesystem'
end

local function exec(opts)
  local ok, command = pcall(require, 'neo-tree.command')
  if not ok then
    vim.notify('Neo-tree command module not available', vim.log.levels.ERROR)
    return false
  end

  command.execute(opts)
  return true
end

local function get_window()
  local state = get_state()
  if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
    return state.winid
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if window_utils.is_neotree_window(win) then
      return win
    end
  end
end

local function open(opts)
  opts = opts or {}
  local focus_tree = opts.focus ~= false
  opts.focus = nil -- do not forward this flag to neo-tree

  local previous_win
  if not focus_tree then
    previous_win = vim.api.nvim_get_current_win()
  end

  local ok = exec(vim.tbl_extend('force', {
    action = 'focus',
    source = 'filesystem',
    position = 'left',
  }, opts))

  if ok and not focus_tree and previous_win and vim.api.nvim_win_is_valid(previous_win) then
    pcall(vim.api.nvim_set_current_win, previous_win)
  end

  return ok
end

local function close()
  local state = get_state()
  if not state or not state.winid or not vim.api.nvim_win_is_valid(state.winid) then
    return false
  end

  return exec {
    action = 'close',
    source = 'filesystem',
    position = state.current_position or 'left',
  }
end

local function refresh_source(source, opts)
  opts = opts or {}
  return exec(vim.tbl_extend('force', {
    action = 'refresh',
    source = source,
  }, opts))
end

local function schedule_refresh(source, opts)
  if refresh_pending[source] then
    return
  end
  refresh_pending[source] = true
  vim.defer_fn(function()
    refresh_pending[source] = false
    refresh_source(source, opts)
  end, 150)
end

---Toggle between Neo-tree and the previously focused regular window
function M.toggle_focus()
  if window_utils.is_neotree_window() then
    if not window_utils.focus_previous_regular_window() then
      close()
    end
    return
  end

  local win = get_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    return
  end

  open { reveal = true }
end

---Toggle Neo-tree visibility entirely
function M.toggle()
  if not close() then
    open { reveal = true, focus = false }
  end
end

---Focus Neo-tree without affecting the previous buffer
function M.focus()
  local win = get_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    return
  end

  open()
end

---Reveal the current buffer in Neo-tree, focusing the tree if needed
function M.reveal_current_file()
  open { reveal = true, focus = true }
end

function M.refresh_filesystem(opts)
  refresh_source('filesystem', opts)
end

function M.refresh_git_status(opts)
  refresh_source('git_status', opts or { position = 'float' })
end

function M.schedule_git_status_refresh()
  schedule_refresh('git_status', { position = 'float' })
end

function M.schedule_filesystem_refresh()
  schedule_refresh('filesystem')
end

return M
