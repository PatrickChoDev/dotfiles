local uv = vim.uv or vim.loop
local SAVE_DELAY_MS = 3000

local autosave_group = vim.api.nvim_create_augroup('CustomAutoSave', { clear = true })
local timers = {}

local function clear_timer(bufnr)
  local timer = timers[bufnr]
  if timer then
    timer:stop()
    timer:close()
    timers[bufnr] = nil
  end
end

local function should_save(bufnr)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  local bo = vim.bo[bufnr]
  if not bo.modified or not bo.modifiable or bo.readonly then
    return false
  end

  if bo.buftype ~= '' then
    return false
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return false
  end

  return true
end

local function save_buffer(bufnr)
  if not should_save(bufnr) then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.cmd, 'silent! write')
  end)
end

local function schedule_save(bufnr, delay)
  clear_timer(bufnr)

  if not should_save(bufnr) then
    return
  end

  local timer = uv.new_timer()
  if not timer then
    save_buffer(bufnr)
    return
  end

  timers[bufnr] = timer
  timer:start(
    delay or SAVE_DELAY_MS,
    0,
    vim.schedule_wrap(function()
      clear_timer(bufnr)
      save_buffer(bufnr)
    end)
  )
end

local function restart_timer(bufnr)
  if timers[bufnr] then
    schedule_save(bufnr)
  end
end

vim.api.nvim_create_autocmd('BufLeave', {
  group = autosave_group,
  callback = function(event)
    local bufnr = event.buf
    clear_timer(bufnr)
    save_buffer(bufnr)
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = autosave_group,
  callback = function(event)
    schedule_save(event.buf)
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = autosave_group,
  callback = function(event)
    clear_timer(event.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'TextChanged', 'TextChangedI' }, {
  group = autosave_group,
  callback = function(event)
    restart_timer(event.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'BufWipeout', 'BufDelete' }, {
  group = autosave_group,
  callback = function(event)
    clear_timer(event.buf)
  end,
})
