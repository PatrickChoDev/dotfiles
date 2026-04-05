local resession = require 'resession'

resession.setup {
  autosave = {
    enable = true,
    interval = 60,
    notify = true,
  },
  extensions = {
    quickfix = {},
    hbac = {},
  },
}

require('telescope').load_extension 'hbac'

local ok_neotree, neotree_utils = pcall(require, 'core.utils.neotree')

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local loaded_session = false
    local argc = vim.fn.argc(-1)
    local argv0 = vim.fn.argv(0)
    local dir_arg = vim.fn.resolve(vim.fn.expand(argv0))
    local is_dir_arg = argc == 1 and vim.fn.isdirectory(dir_arg) == 1
    local using_stdin = vim.g.using_stdin

    if is_dir_arg and not using_stdin then
      vim.cmd('cd ' .. vim.fn.fnameescape(dir_arg))
      local ok = pcall(resession.load, vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
      loaded_session = ok
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == '' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      local bufs = vim.api.nvim_list_bufs()
      if #bufs > 0 then
        vim.cmd('buffer ' .. bufs[1])
      end
    end

    if loaded_session and ok_neotree and neotree_utils.session_post_restore then
      neotree_utils.session_post_restore()
    elseif loaded_session then
      vim.defer_fn(function()
        pcall(vim.cmd, 'Neotree close')
      end, 50)
    end

    if not loaded_session and not using_stdin and (argc == 0 or is_dir_arg) then
      if ok_neotree and neotree_utils.session_open_if_needed then
        neotree_utils.session_open_if_needed()
      else
        vim.cmd 'Neotree filesystem show float'
      end
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
    vim.g.using_stdin = true
  end,
})

-- Keymaps
vim.keymap.set('n', '<leader>sp', function()
  require('telescope').extensions.resession.resession()
end, { desc = 'Search sessions' })
vim.keymap.set('n', '<leader>ps', function()
  resession.save(vim.fn.getcwd(), { notify = true })
end, { desc = 'Save session' })
vim.keymap.set('n', '<leader>pr', function()
  resession.load(vim.fn.getcwd())
end, { desc = 'Restore session' })
vim.keymap.set('n', '<leader>pd', function()
  resession.delete(vim.fn.getcwd())
end, { desc = 'Delete session' })
