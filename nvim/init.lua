require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets
require 'core.autosave' -- Auto save helpers
require('core.title').setup() -- Keep window title in sync with project root
require('core.terminal').setup() -- Terminal helpers
require('core.scroll').setup() -- Dynamic scroll offsets

-- Install and load all plugins via vim.pack (Neovim 0.12 built-in)
require 'pack'

-- Configure plugins in dependency order
require 'plugins.colortheme' -- theme must come first
require 'plugins.notify' -- notifications early so other plugins can use them
require 'plugins.treesitter'
require 'plugins.telescope'
require 'plugins.mason'
require 'plugins.lsp'
require 'plugins.autocompletion'
require 'plugins.lualine'
require 'plugins.neotree'
require 'plugins.debugger'
require 'plugins.gitsigns'
require 'plugins.git'
require 'plugins.alpha'
require 'plugins.indent-blankline'
require 'plugins.misc'
require 'plugins.comment'
require 'plugins.resession'
require 'plugins.multi-cursor'
require 'plugins.conform'
require 'plugins.nvim-lint'
require 'plugins.winshift'
require 'plugins.scope'
require 'plugins.folding'
require 'plugins.ide' -- trouble, fidget, illuminate, which-key
