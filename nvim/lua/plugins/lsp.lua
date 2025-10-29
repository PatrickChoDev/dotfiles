return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', config = true },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'rcarriga/nvim-notify', opts = { background_colour = '#000000' } },
    'saghen/blink.cmp',
  },
  config = function()
    local sign = function(opts)
      vim.diagnostic.config {
        signs = {
          -- Enable signs and assign a table of diagnostic types to symbols
          active = true,
          values = {
            { name = opts.name, text = opts.text, texthl = opts.name },
          },
        },
        virtual_text = true, -- or false if you don’t want inline text
        underline = true, -- or false
        severity_sort = true, -- optional
      }
    end

    sign { name = 'DiagnosticSignError', text = '' }
    sign { name = 'DiagnosticSignWarn', text = '' }
    sign { name = 'DiagnosticSignHint', text = '' }
    sign { name = 'DiagnosticSignInfo', text = '' }

    vim.diagnostic.config {
      virtual_text = true,
      signs = true,
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        border = 'single',
        source = 'always',
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
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>Th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle inlay [H]ints')
          -- Legacy keymap for backward compatibility
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    require('mason').setup {
      ui = {
        icons = {
          package_installed = '',
          package_pending = '',
          package_uninstalled = '',
        },
      },
    }
    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'ts_ls',
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
  end,
}
