return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    -- Directories to suppress auto-session
    suppressed_dirs = { '~/', '~/Downloads', '/', '/tmp' },

    -- Don't save session for these filetypes
    bypass_save_filetypes = {
      'alpha',
      'dashboard',
      'startify',
      'lazy',
      'TelescopePrompt',
      'neo-tree',
      'neo-tree-popup',
      'notify',
      'oil',
    },

    purge_after_minutes = 43200,
    git_use_branch_name = true,
    cwd_change_handling = true,
    legacy_cmds = false,
    session_lens = {
      picker = 'telescope',
      load_on_setup = true,
    },

    log_level = 'error',

    -- Close any empty/new buffers before restoring session
    pre_restore_cmds = {
      function()
        -- Close empty buffers that were created on startup
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == '' then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            if #lines == 1 and lines[1] == '' then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end
      end,
    },
  },

  keys = {
    { '<leader>sp', '<cmd>AutoSession search<CR>', desc = 'Search sessions' },
    { '<leader>ps', '<cmd>AutoSession save<CR>', desc = 'Save session' },
    { '<leader>pr', '<cmd>AutoSession restore<CR>', desc = 'Restore session' },
    { '<leader>pd', '<cmd>AutoSession delete<CR>', desc = 'Delete session' },
    { '<leader>px', '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
  },
}
