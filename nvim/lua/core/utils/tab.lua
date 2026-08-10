-- Tab utility functions

local M = {}

function M.move_tab_to_window()
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr('$')

  if total_tabs == 1 then
    vim.notify('Already in the only tab. Use <leader>wv or <leader>wh to split.', vim.log.levels.WARN)
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()

  -- Close current tab
  vim.cmd 'tabclose'

  -- Open buffer in a new split in the previous tab
  vim.cmd 'vsplit'
  vim.api.nvim_set_current_buf(current_buf)
end

function M.move_tab_to_tab_number()
  local total_tabs = vim.fn.tabpagenr('$')

  if total_tabs == 1 then
    vim.notify('Only one tab exists', vim.log.levels.WARN)
    return
  end

  -- Prompt for tab number
  local target = vim.fn.input('Move to tab number (1-' .. total_tabs .. '): ')
  target = tonumber(target)

  if not target or target < 1 or target > total_tabs then
    vim.notify('Invalid tab number', vim.log.levels.ERROR)
    return
  end

  local current_tab = vim.fn.tabpagenr()
  if target == current_tab then
    vim.notify('Already in tab ' .. target, vim.log.levels.WARN)
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()

  -- Close current tab
  vim.cmd 'tabclose'

  -- Go to target tab (adjust if we closed a tab before the target)
  if current_tab < target then
    vim.cmd('tabn ' .. (target - 1))
  else
    vim.cmd('tabn ' .. target)
  end

  -- Open buffer in a new split
  vim.cmd 'vsplit'
  vim.api.nvim_set_current_buf(current_buf)
end

return M
