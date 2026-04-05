require('Comment').setup {}

vim.keymap.set('n', '<C-/>', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = 'Toggle comment line' })

vim.keymap.set('v', '<C-/>', function()
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { desc = 'Toggle comment selection' })
