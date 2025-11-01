return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'rust',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldenable = false
    vim.opt.viewoptions = { 'folds', 'cursor' }

    -- Auto save folds if buffer has folds and cursor is not at start
    vim.api.nvim_create_autocmd('BufWinLeave', {
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local has_folds = vim.fn.foldlevel '$' > 0

        if vim.bo.buftype == '' and vim.fn.bufname() ~= '' and cursor_line > 1 and line_count > 1 and has_folds then
          vim.cmd 'silent! mkview'
        end
      end,
    })

    -- Auto load folds if view exists
    vim.api.nvim_create_autocmd('BufWinEnter', {
      callback = function()
        if vim.bo.buftype == '' and vim.fn.bufname() ~= '' then
          pcall(vim.cmd, 'silent! loadview')
        end
      end,
    })

    -- 🧹 Clean old view files older than 3 days
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local view_path = vim.fn.stdpath 'state' .. '/view'
        local files = vim.fn.glob(view_path .. '/*', true, true)

        local max_age = 3 * 24 * 60 * 60 -- 3 days
        local now = os.time()

        for _, f in ipairs(files) do
          local stat = vim.loop.fs_stat(f)
          if stat and now - stat.mtime.sec > max_age then
            vim.fn.delete(f)
          end
        end
      end,
    })
  end,
}
