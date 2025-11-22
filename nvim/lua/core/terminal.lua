local M = {}

local window_utils = require 'core.utils.window'

-- -----------------------------------------------------------------------------
-- State tracking
-- -----------------------------------------------------------------------------
local terminal_counter = 0
local pending_directions = {}
local active_terminals = {}

local TerminalRegistry = {}

-- -----------------------------------------------------------------------------
-- Helpers
-- -----------------------------------------------------------------------------

local function terminal_label_text(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return 'Terminal'
  end
  local title = vim.b[bufnr] and vim.b[bufnr].term_title
  if type(title) == 'string' and title ~= '' then
    return title
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name ~= '' then
    return vim.fn.fnamemodify(name, ':t')
  end
  return string.format('Terminal %d', bufnr)
end
local function refresh_statusline()
  local ok, lualine = pcall(require, 'lualine')
  if ok and type(lualine.refresh) == 'function' then
    lualine.refresh {
      place = { 'statusline' },
      trigger = 'core_terminal_update',
    }
  end
end

local function fnameescape(path)
  return vim.fn.fnameescape(path)
end

local function get_terminal_root()
  local ok_title, title = pcall(require, 'core.title')
  if ok_title and title.root_dir then
    local root = title.root_dir()
    if root and root ~= '' then
      return root
    end
  end
  return vim.fn.getcwd()
end

local function queue_direction(direction)
  table.insert(pending_directions, direction)
end

local function pop_direction()
  if #pending_directions == 0 then
    return nil
  end
  local direction = pending_directions[1]
  table.remove(pending_directions, 1)
  return direction
end

local function get_job_id(bufnr)
  local ok, job_id = pcall(vim.api.nvim_buf_get_var, bufnr, 'terminal_job_id')
  if ok and type(job_id) == 'number' then
    return job_id
  end
end

local function job_is_running(job_id)
  if not job_id or job_id <= 0 then
    return false
  end
  local result = vim.fn.jobwait({ job_id }, 0)[1]
  return result == -1
end

-- -----------------------------------------------------------------------------
-- Terminal registry
-- -----------------------------------------------------------------------------

function TerminalRegistry.add(bufnr, direction)
  active_terminals[bufnr] = {
    direction = direction or 'other',
  }
  TerminalRegistry.refresh(bufnr)
end

function TerminalRegistry.remove(bufnr)
  if active_terminals[bufnr] then
    active_terminals[bufnr] = nil
    refresh_statusline()
  end
end

function TerminalRegistry.refresh(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    TerminalRegistry.remove(bufnr)
    return
  end

  local entry = active_terminals[bufnr]
  if not entry then
    return
  end

  entry.job_id = get_job_id(bufnr)
  entry.label = terminal_label_text(bufnr)
  refresh_statusline()
end

local function close_terminal_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    TerminalRegistry.remove(bufnr)
    return
  end

  TerminalRegistry.remove(bufnr)

  local info = vim.fn.getbufinfo(bufnr)[1]
  local windows = info and info.windows or {}
  for _, win in ipairs(windows) do
    if vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end

  if vim.api.nvim_buf_is_valid(bufnr) then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end
end

local function focus_terminal_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local win = vim.fn.bufwinid(bufnr)
  if win ~= -1 and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd 'botright split'
    vim.api.nvim_set_current_buf(bufnr)
  end

  TerminalRegistry.refresh(bufnr)

  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.cmd('startinsert')
    end
  end)
end

function TerminalRegistry.list()
  local list = {}
  for bufnr, info in pairs(active_terminals) do
    local job_id = info.job_id or get_job_id(bufnr)
    table.insert(list, {
      bufnr = bufnr,
      job_id = job_id,
      running = job_is_running(job_id),
      direction = info.direction,
      label = info.label or terminal_label_text(bufnr),
    })
  end

  table.sort(list, function(a, b)
    if a.running ~= b.running then
      return a.running and not b.running
    end
    return a.label < b.label
  end)

  return list
end

local function ensure_neotree_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if window_utils.is_neotree_window(win) then
      return
    end
  end

  vim.schedule(function()
    local ok_command, command = pcall(require, 'neo-tree.command')
    if ok_command then
      local previous_win = vim.api.nvim_get_current_win()
      command.execute {
        action = 'focus',
        source = 'filesystem',
        position = 'left',
      }
      if previous_win and vim.api.nvim_win_is_valid(previous_win) then
        pcall(vim.api.nvim_set_current_win, previous_win)
      end
    else
      vim.cmd('Neotree filesystem show left')
      vim.cmd('wincmd p')
    end
  end)
end

local function terminal_title(bufnr, root)
  terminal_counter = terminal_counter + 1
  local label = string.format('Terminal %02d', terminal_counter)
  local parts = { label }

  if root and root ~= '' then
    local short_root = vim.fn.fnamemodify(root, ':t')
    if short_root == '' then
      short_root = root
    end
    table.insert(parts, string.format('[%s]', short_root))
  end

  local direction = vim.b[bufnr] and vim.b[bufnr].core_terminal_direction or nil
  if direction == 'vertical' then
    table.insert(parts, '(vsplit)')
  elseif direction == 'horizontal' then
    table.insert(parts, '(hsplit)')
  end

  vim.b[bufnr].term_title = table.concat(parts, ' ')
end

local function prepare_terminal_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_buf_set_option(bufnr, 'buflisted', false)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'terminal')

  local root = get_terminal_root()
  if root and root ~= '' then
    pcall(vim.cmd, 'lcd ' .. fnameescape(root))
  end

  terminal_title(bufnr, root)
end

function M.setup()
  local group = vim.api.nvim_create_augroup('CoreTerminal', { clear = true })

  vim.api.nvim_create_autocmd('TermOpen', {
    group = group,
    callback = function(event)
      local direction = pop_direction()
      vim.b[event.buf].core_terminal_direction = direction or 'other'

      prepare_terminal_buffer(event.buf)
      TerminalRegistry.add(event.buf, vim.b[event.buf].core_terminal_direction)
      ensure_neotree_visible()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(event.buf) and vim.api.nvim_buf_get_option(event.buf, 'buftype') == 'terminal' then
          if vim.api.nvim_get_current_buf() == event.buf then
            vim.cmd('startinsert')
          end
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd('TermEnter', {
    group = group,
    callback = function(event)
      if vim.bo.buftype == 'terminal' then
        TerminalRegistry.refresh(event.buf or vim.api.nvim_get_current_buf())
        vim.cmd('startinsert')
      end
    end,
  })

  local function focus_terminal()
    if vim.bo.buftype == 'terminal' then
      local mode = vim.api.nvim_get_mode().mode
      TerminalRegistry.refresh(vim.api.nvim_get_current_buf())
      if mode ~= 't' then
        vim.cmd('startinsert')
      end
    end
  end

  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
    group = group,
    callback = focus_terminal,
  })

  vim.api.nvim_create_autocmd('TermClose', {
    group = group,
    callback = function(event)
      TerminalRegistry.remove(event.buf)
      vim.schedule(function()
        close_terminal_buffer(event.buf)
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(event)
      TerminalRegistry.remove(event.buf)
    end,
  })

  -- Prompt on quit removed
end

local function adjust_split_size(direction, win, opts)
  if direction == 'horizontal' then
    local ratio = opts and opts.height_ratio
    if ratio and ratio > 0 and ratio < 1 then
      local available = vim.o.lines - vim.o.cmdheight
      local target = math.max(3, math.floor(available * ratio))
      pcall(vim.api.nvim_win_set_height, win, target)
    elseif opts and opts.height then
      pcall(vim.api.nvim_win_set_height, win, math.max(opts.height, 1))
    end
  elseif direction == 'vertical' and opts then
    local ratio = opts.width_ratio
    if ratio and ratio > 0 and ratio < 1 then
      local available = vim.o.columns
      local target = math.max(10, math.floor(available * ratio))
      pcall(vim.api.nvim_win_set_width, win, target)
    elseif opts.width then
      pcall(vim.api.nvim_win_set_width, win, math.max(opts.width, 1))
    end
  end
end

local function open_terminal_split(direction, opts)
  queue_direction(direction)
  if direction == 'vertical' then
    vim.cmd 'vsplit'
  else
    vim.cmd 'split'
  end

  local term_win = vim.api.nvim_get_current_win()
  adjust_split_size(direction, term_win, opts)

  local ok, err = pcall(vim.cmd, 'terminal')
  if not ok then
    pending_directions[#pending_directions] = nil
    vim.notify('Failed to open terminal: ' .. err, vim.log.levels.ERROR)
  end
end

function M.open_terminal_vsplit()
  open_terminal_split 'vertical'
end

function M.open_terminal_hsplit(opts)
  open_terminal_split('horizontal', opts)
end

local function matches_direction(info, direction)
  if not direction then
    return true
  end
  return info.direction == direction
end

function M.count(direction)
  local total = 0
  for _, info in pairs(active_terminals) do
    if matches_direction(info, direction) then
      total = total + 1
    end
  end
  if total == 0 then
    return 0
  end
  return total
end

function M.close_buffer(bufnr)
  close_terminal_buffer(bufnr)
end

function M.list_terminals()
  return TerminalRegistry.list()
end

function M.focus_terminal(bufnr)
  focus_terminal_buffer(bufnr)
end

local function format_terminal_entry(entry)
  local icon = entry.running and '' or '󱂬'
  local direction = entry.direction == 'vertical' and '[vsplit]' or entry.direction == 'horizontal' and '[hsplit]' or ''
  return string.format('%s %s %s', icon, entry.label, direction):gsub('%s%s+', ' ')
end

local function telescope_pick_terminal(entries)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local picker = pickers.new({}, {
    prompt_title = 'Terminal Sessions',
    finder = finders.new_table {
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = format_terminal_entry(entry),
          ordinal = entry.label,
          bufnr = entry.bufnr,
        }
      end,
    },
    sorter = conf.generic_sorter {},
  })

  picker:attach_mappings(function()
    local function select(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      if selection and selection.bufnr then
        focus_terminal_buffer(selection.bufnr)
      end
    end

    actions.select_default:replace(select)
    return true
  end)

  picker:find()
end

function M.pick_terminal()
  local entries = TerminalRegistry.list()
  if #entries == 0 then
    vim.notify('No terminal sessions available', vim.log.levels.INFO)
    return
  end

  local ok = pcall(function()
    telescope_pick_terminal(entries)
  end)

  if not ok then
    vim.ui.select(entries, {
      prompt = 'Select terminal session',
      format_item = function(item)
        return format_terminal_entry(item)
      end,
    }, function(choice)
      if choice then
        focus_terminal_buffer(choice.bufnr)
      end
    end)
  end
end

return M
