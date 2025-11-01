return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
  config = function()
    local lint = require 'lint'

    -- Auto-run linters
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
