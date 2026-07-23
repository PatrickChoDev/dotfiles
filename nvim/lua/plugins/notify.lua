local notify = require 'notify'

notify.setup {
  render = 'compact', -- minimal chrome: no big header box
  stages = 'fade', -- smooth fade in/out
  timeout = 3000,
  max_width = 60,
  max_height = 8,
  top_down = false, -- stack from bottom-right upward
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
  },
  -- Don't show "written" / yank / search-count noise via notify
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { zindex = 100 })
  end,
}

-- Route all vim.notify calls through nvim-notify
vim.notify = notify

-- Telescope integration: browse notification history with <leader>nh
pcall(require('telescope').load_extension, 'notify')
--vim.keymap.set('n', '<leader>nh', '<cmd>Telescope notify<cr>', { desc = 'Notification history' })
--vim.keymap.set('n', '<leader>nd', function()
--  notify.dismiss { silent = true, pending = true }
--end, { desc = 'Dismiss notifications' })

-- Scroll LSP hover/signature floats with C-f/C-b (native float scroll)
vim.keymap.set({ 'n' }, '<C-f>', function()
  local wins = vim.api.nvim_list_wins()
  for _, w in ipairs(wins) do
    local cfg = vim.api.nvim_win_get_config(w)
    if cfg.relative ~= '' then -- floating window exists
      vim.api.nvim_win_call(w, function()
        vim.cmd 'normal! <C-d>'
      end)
      return
    end
  end
  return '<C-f>'
end, { silent = true, desc = 'Scroll float/page forward' })
