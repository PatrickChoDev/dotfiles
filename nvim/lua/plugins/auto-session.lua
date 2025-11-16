return {
  'rmagatti/auto-session',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    enabled = true,
    auto_save = true,
    auto_restore = true,
    auto_restore_last_session = false,
    auto_create = true,
    git_use_branch_name = true,
    cwd_change_handling = true,
    bypass_save_filetypes = { 'alpha', 'neo-tree', 'gitcommit' },
    close_filetypes_on_save = { 'neo-tree', 'lazy', 'mason' },
    purge_after_minutes = 43200, -- 30 days
    args_allow_files_auto_save = true,
    show_auto_restore_notif = true,
    legacy_cmds = false,
    pre_save_cmds = { 'Neotree close' },
    post_restore_cmds = { 'Neotree filesystem show' },
  },
  config = function(_, opts)
    local auto_session = require 'auto-session'
    auto_session.setup(opts)
    local session_config = require 'auto-session.config'
    vim.g.auto_session_enabled = session_config.auto_save ~= false

    local keymap = vim.keymap.set
    local key_opts = { noremap = true, silent = true }

    local function toggle_auto_session()
      local new_state = not session_config.auto_save
      auto_session.disable_auto_save(new_state)
      vim.g.auto_session_enabled = session_config.auto_save ~= false
    end

    keymap('n', '<leader>ps', '<cmd>AutoSession save<CR>', vim.tbl_extend('force', key_opts, { desc = '[P]roject [S]ave session' }))
    keymap('n', '<leader>pr', '<cmd>AutoSession restore<CR>', vim.tbl_extend('force', key_opts, { desc = '[P]roject [R]estore session' }))
    keymap('n', '<leader>pd', '<cmd>AutoSession delete<CR>', vim.tbl_extend('force', key_opts, { desc = '[P]roject [D]elete session' }))
    keymap('n', '<leader>sp', '<cmd>AutoSession search<CR>', vim.tbl_extend('force', key_opts, { desc = '[S]earch [P]roject sessions' }))
    keymap('n', '<leader>pT', toggle_auto_session, vim.tbl_extend('force', key_opts, { desc = '[P]roject toggle auto-session' }))

    vim.api.nvim_create_autocmd('VimLeavePre', {
      desc = 'Auto-save session on exit',
      callback = function()
        if vim.g.auto_session_enabled then
          pcall(vim.cmd, 'silent! AutoSession save')
        end
      end,
    })

    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function()
        local argv = vim.fn.argv()
        -- Only auto restore when no file arguments are provided
        if #argv == 0 and vim.g.auto_session_enabled then
          local cwd_session = vim.fn.getcwd()
          pcall(function()
            require('auto-session').RestoreSession(cwd_session)
          end)
        end
      end,
    })
  end,
}
