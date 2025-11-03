-- Easily comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  keys = {
    {
      '<C-/>',
      function()
        require('Comment.api').toggle.linewise.current()
      end,
      mode = 'n',
      desc = 'Toggle comment line',
    },
    { '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = 'v', desc = 'Toggle comment selection' },
  },
  opts = {},
}
