-- Neogit: Magit-like git interface for interactive staging, commits, rebase, merge
require('neogit').setup {
  graph_style = 'unicode',
  integrations = {
    diffview = true,
    telescope = true,
  },
}

-- Diffview: side-by-side diffs and merge conflict resolution
require('diffview').setup {
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = 'diff3_mixed',
      disable_diagnostics = true,
    },
  },
}

local neogit = require 'neogit'

-- Main git workflow entry points
vim.keymap.set('n', '<leader>gg', function() neogit.open() end, { desc = '[G]it open Neo[G]it' })
vim.keymap.set('n', '<leader>gm', function() neogit.open { 'merge' } end, { desc = '[G]it [M]erge' })
vim.keymap.set('n', '<leader>gR', function() neogit.open { 'rebase' } end, { desc = '[G]it [R]ebase' })
vim.keymap.set('n', '<leader>gp', function() neogit.open { 'push' } end, { desc = '[G]it [P]ush' })
vim.keymap.set('n', '<leader>gl', function() neogit.open { 'pull' } end, { desc = '[G]it pul[L]' })

-- Diffview operations
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = '[G]it [D]iff all changes' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewClose<CR>', { desc = '[G]it [D]iff close' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = '[G]it file [H]istory' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = '[G]it repo [H]istory' })
