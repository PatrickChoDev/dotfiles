-- Diagnostics-related keymaps

local M = {}

function M.setup()
  -- Diagnostic navigation (using [ and ] prefix for previous/next)
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1, float = true }
  end, { noremap = true, silent = true, desc = 'Previous [D]iagnostic' })

  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1, float = true }
  end, { noremap = true, silent = true, desc = 'Next [D]iagnostic' })

  -- Diagnostic display
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { noremap = true, silent = true, desc = '[C]ode [D]iagnostic float' })
  vim.keymap.set('n', '<leader>cD', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = '[C]ode [D]iagnostics list' })

  -- Legacy keymaps for backward compatibility
  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap = true, silent = true, desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = 'Open diagnostics list' })
end

return M
