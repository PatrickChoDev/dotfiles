-- vim-sleuth: detect tabstop/shiftwidth automatically (no config needed)

-- which-key: hints for keybinds (no config needed, loads automatically)

-- nvim-autopairs: lazy on InsertEnter
vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require('nvim-autopairs').setup {}
  end,
})

-- todo-comments
require('todo-comments').setup { signs = false }

-- zen-mode
require('zen-mode').setup {
  window = {
    backdrop = 1,
    width = 0.7,
    height = 0.95,
    options = {
      number = false,
      relativenumber = false,
      signcolumn = 'no',
    },
  },
  plugins = {
    options = { laststatus = 3 },
    twilight = false,
    gitsigns = true,
    tmux = false,
  },
}
vim.keymap.set('n', '<leader>zm', '<cmd>ZenMode<CR>', { desc = '[Z]en [M]ode toggle' })

-- nvim-colorizer
require('colorizer').setup()
