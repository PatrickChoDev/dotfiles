local M = {}

local window_utils = require 'core.utils.window'

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

local function ensure_neotree_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if window_utils.is_neotree_window(win) then
      return
    end
  end

  vim.schedule(function()
    local ok_command, command = pcall(require, 'neo-tree.command')
    if ok_command then
      command.execute {
        action = 'show',
        source = 'filesystem',
        position = 'left',
        focus = false,
      }
    else
      vim.cmd('Neotree filesystem show left')
      vim.cmd('wincmd p')
    end
  end)
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
end

function M.setup()
  local group = vim.api.nvim_create_augroup('CoreTerminal', { clear = true })

  vim.api.nvim_create_autocmd('TermOpen', {
    group = group,
    callback = function(event)
      prepare_terminal_buffer(event.buf)
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
    callback = function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd('startinsert')
      end
    end,
  })
end

return M

