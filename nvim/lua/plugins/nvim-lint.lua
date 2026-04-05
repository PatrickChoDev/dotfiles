local lint = require 'lint'

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
