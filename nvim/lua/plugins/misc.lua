-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gvdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse', 'GRemove', 'GRename' },
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
    dependencies = { 'tpope/vim-fugitive' },
    event = 'VeryLazy',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
    event = 'VeryLazy',
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 1,
        width = 0.6,
        height = 0.9,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = 'no',
        },
      },
      plugins = {
        options = {
          laststatus = 3,
        },
        twilight = false,
        gitsigns = true,
        tmux = false,
      },
    },
    init = function()
      vim.keymap.set('n', '<leader>zm', '<cmd>ZenMode<CR>', { desc = '[Z]en [M]ode toggle' })
    end,
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('colorizer').setup()
    end,
  },
}
