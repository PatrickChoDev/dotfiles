local M = {}

local cached_root = nil

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

local function build_title(root_path)
  local label = short_name(root_path)
  if label == '' then
    label = vim.fn.getcwd()
  end
  return string.format('NEOVIM %s :: %%t', label)
end

function M.root_dir()
  return get_neotree_root()
end

function M.update()
  local root_path = get_neotree_root()
  if cached_root == root_path then
    return
  end
  cached_root = root_path
  vim.o.titlestring = build_title(root_path)
end

function M.setup()
  M.update()

  local group = vim.api.nvim_create_augroup('CoreTitle', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged', 'VimEnter', 'TabEnter', 'WinEnter' }, {
    group = group,
    callback = function()
      M.update()
    end,
  })
end

return M

