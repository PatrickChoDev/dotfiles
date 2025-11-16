-- Dynamic scroll and sidescroll configuration

local M = {}

local MIN_VERTICAL_PADDING = 4
local MIN_HORIZONTAL_PADDING = 16

local EXCLUDED_FILETYPES = {
  ['neo-tree'] = true,
  ['neo-tree-popup'] = true,
}

local EXCLUDED_BUFTYPES = {
  terminal = true,
}

local function is_float(win)
  local ok, config = pcall(vim.api.nvim_win_get_config, win)
  return ok and config.relative ~= ''
end

local function set_option(win, opt, value)
  pcall(vim.api.nvim_set_option_value, opt, value, { scope = 'local', win = win })
end

local function should_exclude(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  if bufnr == 0 or not vim.api.nvim_buf_is_valid(bufnr) then
    return true
  end

  local bo = vim.bo[bufnr]
  if EXCLUDED_FILETYPES[bo.filetype] then
    return true
  end

  if EXCLUDED_BUFTYPES[bo.buftype] then
    return true
  end

  return false
end

local function apply_to_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) or is_float(win) then
    return
  end

  if should_exclude(win) then
    set_option(win, 'scrolloff', 0)
    set_option(win, 'sidescrolloff', 0)
    return
  end

  local height = vim.api.nvim_win_get_height(win)
  local width = vim.api.nvim_win_get_width(win)

  local vertical = math.max(MIN_VERTICAL_PADDING, math.floor((height - 1) / 2))
  local horizontal = math.max(MIN_HORIZONTAL_PADDING, math.floor((width - 1) / 2))

  set_option(win, 'scrolloff', vertical)
  set_option(win, 'sidescrolloff', horizontal)
end

function M.refresh(target_win)
  if target_win and target_win ~= 0 then
    apply_to_window(target_win)
    return
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    apply_to_window(win)
  end
end

local function window_from_event(event)
  if event and event.win and event.win ~= 0 then
    return event.win
  end

  if event and event.buf then
    local win = vim.fn.bufwinid(event.buf)
    if win ~= -1 then
      return win
    end
  end
end

function M.setup()
  M.refresh()

  local group = vim.api.nvim_create_augroup('CoreDynamicScroll', { clear = true })

  local function handler(event)
    local win = window_from_event(event)
    if win then
      M.refresh(win)
    else
      M.refresh()
    end
  end

  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'TermOpen', 'WinResized' }, {
    group = group,
    callback = handler,
  })

  vim.api.nvim_create_autocmd('VimResized', {
    group = group,
    callback = function()
      M.refresh()
    end,
  })
end

return M

