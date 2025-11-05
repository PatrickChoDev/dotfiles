return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'rcarriga/nvim-notify', opts = { background_colour = '#000000' } },
    'saghen/blink.cmp',
    {
      'adoyle-h/lsp-toggle.nvim',
      config = function()
        require('lsp-toggle').setup {
          create_cmds = true,
          telescope = true,
        }
      end,
    },
    {
      'folke/neoconf.nvim',
      cmd = 'Neoconf',
      config = function()
        require('neoconf').setup {
          import = {
            vscode = true,
            coc = false,
            nlsp = false,
          },
        }
      end,
    },
  },
  config = function()
    local util = require 'lspconfig.util'

    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.HINT] = '',
          [vim.diagnostic.severity.INFO] = '',
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
          [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
          [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
          [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        },
      },

      virtual_text = true,
      underline = true,
      severity_sort = true,
      update_in_insert = true,
      float = {
        border = 'single',
        source = true,
        header = '',
        prefix = '',
      },
    }

    -- LSP keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
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
        map('<leader>cf', function()
          vim.lsp.buf.format { async = true }
        end, '[C]ode [F]ormat')
        map('<leader>ct', require('telescope.builtin').lsp_type_definitions, '[C]ode [T]ype definition')
        map('<leader>cS', require('telescope.builtin').lsp_document_symbols, '[C]ode [S]ymbols in document')
        map('<leader>cw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[C]ode symbols in [W]orkspace')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>Th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle inlay [H]ints')
        end
      end,
    })

    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'ts_ls',
        'denols',
        'html',
        'cssls',
        'pylsp',
        'jsonls',
        'tailwindcss',
        'dockerls',
        'sqlls',
        'terraformls',
        'yamlls',
        'rust_analyzer',
        'clangd',
      },
      automatic_installation = true,
    }

    require('mason-tool-installer').setup {
      ensure_installed = {
        'stylua',
        'prettier',
        'black',
        'isort',
        'shfmt',
        'taplo',
        'ruff',
        'eslint_d',
        'hadolint',
        'clang-format',
      },
    }

    local deno_root = util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock')
    local node_root = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', 'pnpm-workspace.yaml', 'package-lock.json', 'yarn.lock')

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
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
          },
        },
      },
    })

    vim.lsp.config('rust_analyzer', {
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
          check = {
            command = 'clippy',
          },
        },
      },
    })

    vim.lsp.config('denols', {
      root_dir = deno_root,
      single_file_support = false,
    })

    vim.lsp.config('ts_ls', {
      root_dir = function(fname)
        if deno_root(fname) then
          return nil
        end
        return node_root(fname)
      end,
      single_file_support = false,
    })

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      update_in_insert = true,
    })

    local toggle_mappings = {
      { keys = '<leader>cT', command = 'LspToggleAuto', desc = '[C]ode toggle LSP (auto)' },
      { keys = '<leader>cB', command = 'LspToggleBuffer', desc = '[C]ode toggle LSP (buffer)' },
    }

    for _, mapping in ipairs(toggle_mappings) do
      if vim.fn.exists(':' .. mapping.command) == 2 then
        vim.keymap.set('n', mapping.keys, '<cmd>' .. mapping.command .. '<CR>', { desc = mapping.desc, silent = true })
      end
    end
  end,
}
