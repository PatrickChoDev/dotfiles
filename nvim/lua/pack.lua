-- Plugin manager: vim.pack (built-in, Neovim 0.12+)
-- Usage: vim.pack.update() to update all plugins
local gh = function(x)
  return 'https://github.com/' .. x
end

-- Build hooks for plugins that require post-install compilation
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      vim.cmd 'TSUpdate'
    end
  end,
})

-- Force load=true so all plugins are added to rtp and loadable immediately,
-- even when called from init.lua before VimEnter.
vim.pack.add({
  -- Theme (load first — priority plugin)
  { src = gh 'catppuccin/nvim', name = 'catppuccin' },

  -- Icons & UI dependencies
  gh 'nvim-tree/nvim-web-devicons',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-lua/plenary.nvim',

  -- Notifications
  gh 'rcarriga/nvim-notify',

  -- File explorer
  { src = gh 'nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
  gh '3rd/image.nvim',
  { src = gh 's1n7ax/nvim-window-picker', version = vim.version.range '>=2.0.0, <3.0.0' },

  -- Statusline
  gh 'nvim-lualine/lualine.nvim',

  -- Syntax / Treesitter
  {src = gh 'nvim-treesitter/nvim-treesitter', version = "main"},

  -- Fuzzy finder
  { src = gh 'nvim-telescope/telescope.nvim', version = 'master' },
  gh 'nvim-telescope/telescope-fzf-native.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
  gh 'scottmckendry/pick-resession.nvim',

  -- LSP
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'adoyle-h/lsp-toggle.nvim',
  gh 'folke/neoconf.nvim',
  { src = gh 'elixir-tools/elixir-tools.nvim', name = 'elixir-tools', version = 'stable' },

  -- Completion
  { src = gh 'saghen/blink.cmp', version = vim.version.range '>=1.0.0, <2.0.0' },
  gh 'rafamadriz/friendly-snippets',

  -- Debugger
  gh 'mfussenegger/nvim-dap',
  gh 'rcarriga/nvim-dap-ui',
  gh 'nvim-neotest/nvim-nio',
  gh 'jay-babu/mason-nvim-dap.nvim',
  gh 'leoluz/nvim-dap-go',

  -- Git
  gh 'lewis6991/gitsigns.nvim',
  gh 'tpope/vim-fugitive',
  gh 'tpope/vim-rhubarb',

  -- Dashboard
  gh 'goolord/alpha-nvim',
  gh 'rubiin/fortune.nvim',

  -- Indent guides
  gh 'lukas-reineke/indent-blankline.nvim',

  -- Editor utilities
  gh 'tpope/vim-sleuth',
  gh 'folke/which-key.nvim',
  gh 'windwp/nvim-autopairs',
  gh 'folke/todo-comments.nvim',
  gh 'folke/zen-mode.nvim',
  { src = gh 'norcalli/nvim-colorizer.lua', name = 'nvim-colorizer' },

  -- Comments
  gh 'numToStr/Comment.nvim',

  -- Session management
  gh 'stevearc/resession.nvim',
  gh 'axkirillov/hbac.nvim',
  gh 'tiagovla/scope.nvim',

  -- Command UI
  gh 'folke/noice.nvim',

  -- Multi-cursor
  { src = gh 'mg979/vim-visual-multi', version = 'master' },

  -- Formatter & linter
  gh 'stevearc/conform.nvim',
  gh 'mfussenegger/nvim-lint',

  -- Window management
  gh 'sindrets/winshift.nvim',
}, { load = true })
