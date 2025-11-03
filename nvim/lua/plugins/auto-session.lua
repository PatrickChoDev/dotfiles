return {
  'rmagatti/auto-session',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    auto_session_enable_last_session = true,
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
    cwd_change_handling = true,
    bypass_session_save_file_types = { 'alpha', 'neo-tree', 'gitcommit' },
    session_lens = {
      load_on_setup = true,
      picker = 'telescope',
      previewer = 'summary',
    },
    suppressed_dirs = { '~', '~/Downloads', '~/Documents', '~/Desktop' },
    close_filetypes_on_save = {
      'checkhealth',
      'help',
      'qf',
      'lspinfo',
      'null-ls-info',
      'toggleterm',
      'terminal',
      'lazy',
      'mason',
      'notify',
      'spectre_panel',
      'TelescopePrompt',
      'DressingSelect',
      'neo-tree',
    },
    purge_after_minutes = 43200, -- 30 days
    show_auto_restore_notif = true,
    legacy_cmds = false,
    pre_save_cmds = { 'Neotree close' },
    post_restore_cmds = { 'Neotree filesystem show' },
  },
  config = function(_, opts)
    local auto_session = require 'auto-session'
    auto_session.setup(opts)

    local keymap = vim.keymap.set
    local key_opts = { noremap = true, silent = true }

    keymap('n', '<leader>ps', '<cmd>AutoSession save<CR>', vim.tbl_extend('force', key_opts, { desc = '[P]roject [S]ave session' }))
    keymap('n', '<leader>pr', '<cmd>AutoSession restore<CR>', vim.tbl_extend('force', key_opts, { desc = '[P]roject [R]estore session' }))
    keymap('n', '<leader>pd', '<cmd>AutoSession delete<CR>', vim.tbl_extend('force', key_opts, { desc = '[P]roject [D]elete session' }))
    keymap('n', '<leader>sp', '<cmd>AutoSession search<CR>', vim.tbl_extend('force', key_opts, { desc = '[S]earch [P]roject sessions' }))
  end,
}
