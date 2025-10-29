return {
  'stevearc/resession.nvim',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    autosave = {
      enable = true,
      interval = 60,
      notify = true,
    },
    extensions = {
      quickfix = {},
    },
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        if vim.fn.argc(-1) == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 and not vim.g.using_stdin then
          local dir_arg = vim.fn.argv(0)
          vim.cmd('cd ' .. vim.fn.fnameescape(dir_arg))
          resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })

          -- Remove [No Name] buffer
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_name(buf) == '' and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end

          -- Move to first remaining buffer
          local bufs = vim.api.nvim_list_bufs()
          if #bufs > 0 then
            vim.cmd('buffer ' .. bufs[1])
          end

          -- Refocus main editor window (not Neo-tree)
          vim.defer_fn(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local name = vim.api.nvim_buf_get_name(buf)
              if not name:match 'neo%-tree' then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
          end, 100)

          vim.notify('Loaded session for ' .. vim.fn.getcwd(), vim.log.levels.INFO)
        elseif vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
          -- Load dashboard for nvim with no arguments
        end
      end,
      nested = true,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = true })
      end,
    })
    vim.api.nvim_create_autocmd('StdinReadPre', {
      callback = function()
        -- Store this for later
        vim.g.using_stdin = true
      end,
    })
  end,
  keys = {
    {
      '<leader>sp',
      function()
        require('telescope').extensions.resession.resession()
      end,
      desc = 'Search sessions',
    },
    {
      '<leader>ps',
      function()
        require('resession').save(vim.fn.getcwd(), { notify = true })
      end,
      desc = 'Save session',
    },
    {
      '<leader>pr',
      function()
        require('resession').load(vim.fn.getcwd())
      end,
      desc = 'Restore session',
    },
    {
      '<leader>pd',
      function()
        require('resession').delete(vim.fn.getcwd())
      end,
      desc = 'Delete session',
    },
  },
}
