local M = {}

local last_title = nil

local function get_neotree_root()
  local ok_manager, manager = pcall(require, 'neo-tree.sources.manager')
  if ok_manager then
    local state = manager.get_state 'filesystem'
    if state and type(state.path) == 'string' and state.path ~= '' then
      return state.path
    end
  end
  return vim.fn.getcwd()
end

local function short_name(path)
  local name = vim.fn.fnamemodify(path or '', ':t')
  if name == '' then
    return path or ''
  end
  return name
end

local function terminal_label(bufnr)
  local ok_job, job_id = pcall(vim.api.nvim_buf_get_var, bufnr, 'terminal_job_id')
  if ok_job and type(job_id) == 'number' and vim.fn.exists('*jobinfo') == 1 then
    local info = vim.fn.jobinfo(job_id) or {}
    local cmd = info.cmd
    if type(cmd) == 'table' and #cmd > 0 then
      local executable = short_name(cmd[1])
      local args = table.concat(cmd, ' ', 2)
      if args ~= '' then
        return string.format('Terminal: %s %s', executable, args)
      end
      return string.format('Terminal: %s', executable)
    end
  end

  local term_title = vim.b[bufnr] and vim.b[bufnr].term_title
  if type(term_title) == 'string' and term_title ~= '' then
    return string.format('Terminal: %s', term_title)
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name and name ~= '' then
    local tail = name:match('term://[^/]+/(.+)')
    if tail then
      tail = tail:gsub('//', '/')
      local command = tail:match('([^/]+)$')
      if command and command ~= '' then
        return string.format('Terminal: %s', command)
      end
    end
  end

  return 'Terminal'
end

local function buffer_label(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return '[No Name]'
  end

  local buftype = vim.bo[bufnr].buftype

  if buftype == 'terminal' then
    return terminal_label(bufnr)
  end

  if buftype == 'help' then
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= '' then
      return string.format('help:%s', short_name(name))
    end
    return 'help'
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return '[No Name]'
  end

  return short_name(name)
end

local function build_title(root_path, bufnr)
  local label = short_name(root_path)
  if label == '' then
    local fallback = vim.fn.getcwd()
    label = short_name(fallback)
  end

  local buffer_name = buffer_label(bufnr)
  return string.format('NEOVIM %s :: %s', label, buffer_name)
end

function M.root_dir()
  return get_neotree_root()
end

function M.update(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local root_path = get_neotree_root()
  local title = build_title(root_path, bufnr)

  if last_title == title then
    return
  end

  last_title = title
  vim.o.titlestring = title
end

function M.setup()
  M.update()

  local group = vim.api.nvim_create_augroup('CoreTitle', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged', 'VimEnter', 'TabEnter', 'WinEnter', 'TermEnter', 'TermOpen', 'TermLeave', 'TermClose' }, {
    group = group,
    callback = function(event)
      M.update(event.buf)
    end,
  })
end

return M
