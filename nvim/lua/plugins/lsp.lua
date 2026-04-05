local util = require 'lspconfig.util'

local icons = {
  [vim.diagnostic.severity.ERROR] = '',
  [vim.diagnostic.severity.WARN] = '',
  [vim.diagnostic.severity.HINT] = '',
  [vim.diagnostic.severity.INFO] = '',
}

vim.diagnostic.config {
  signs = false,
  virtual_text = {
    severity_sort = true,
    spacing = 4,
    prefix = '',
    format = function(diagnostic)
      local title = vim.split(diagnostic.message, '\n')[1]
      if #title > 30 then
        return string.format(' %s %s...', icons[diagnostic.severity], string.sub(title, 1, 30))
      end
      return string.format(' %s %s', icons[diagnostic.severity], title)
    end,
  },
  underline = true,
  severity_sort = true,
  update_in_insert = true,
  float = {
    border = 'single',
    source = 'if_many',
    header = '',
    prefix = '',
    scope = 'line',
  },
}

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { 'CursorMoved', 'CursorMovedI', 'BufHidden', 'InsertCharPre' },
    })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
    map('<leader>cf', function() vim.lsp.buf.format { async = true } end, '[C]ode [F]ormat')
    map('<leader>ct', require('telescope.builtin').lsp_type_definitions, '[C]ode [T]ype definition')
    map('<leader>cS', require('telescope.builtin').lsp_document_symbols, '[C]ode [S]ymbols in document')
    map('<leader>cw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[C]ode symbols in [W]orkspace')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('LspHighlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('LspHighlightDetach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'LspHighlight', buffer = event2.buf }
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>Th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle inlay [H]ints')
    end
  end,
})

require('mason-lspconfig').setup {
  ensure_installed = {
    'lua_ls', 'ts_ls', 'denols', 'html', 'cssls', 'pylsp', 'jsonls',
    'tailwindcss', 'dockerls', 'sqlls', 'terraformls', 'yamlls',
    'rust_analyzer', 'clangd',
  },
  automatic_installation = true,
}

require('mason-tool-installer').setup {
  ensure_installed = {
    'stylua', 'prettier', 'black', 'isort', 'shfmt', 'taplo',
    'ruff', 'eslint_d', 'hadolint', 'clang-format',
  },
}

vim.lsp.enable 'gleam'

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      format = { enable = false },
    },
  },
})

vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = false }, pycodestyle = { enabled = false },
        autopep8 = { enabled = false }, yapf = { enabled = false },
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      check = { command = 'clippy' },
    },
  },
})

vim.lsp.handlers['textDocument/publishDiagnostics'] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = true })

-- LSP toggle keymaps (set lazily once commands are registered)
vim.api.nvim_create_autocmd('User', {
  pattern = 'LspToggleReady',
  once = true,
  callback = function()
    vim.keymap.set('n', '<leader>cT', '<cmd>LspToggleAuto<CR>', { desc = '[C]ode toggle LSP (auto)', silent = true })
    vim.keymap.set('n', '<leader>cB', '<cmd>LspToggleBuffer<CR>', { desc = '[C]ode toggle LSP (buffer)', silent = true })
  end,
})

-- Elixir tools
require('elixir').setup {
  nextls = { enable = true },
  elixirls = {
    enable = true,
    settings = require('elixir.elixirls').settings {
      dialyzerEnabled = true,
      enableTestLenses = true,
    },
  },
  projectionist = { enable = true },
}

-- neoconf (project-local LSP settings)
require('neoconf').setup {
  import = { vscode = true, coc = false, nlsp = false },
}

-- lsp-toggle
require('lsp-toggle').setup { create_cmds = true, telescope = true }
