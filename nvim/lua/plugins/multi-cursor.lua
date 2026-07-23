vim.api.nvim_create_autocmd('User', {
  pattern = 'visual_multi_start',
  callback = function()
    vim.notify('Multi-cursor mode activated', vim.log.levels.INFO)
  end,
})
