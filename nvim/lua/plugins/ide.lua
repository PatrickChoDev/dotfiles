-- IDE quality-of-life improvements

-- ── Trouble: diagnostics / references / quickfix panel ──────────────────────
require('trouble').setup {
  modes = {
    diagnostics = { auto_close = true },
  },
}

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })
vim.keymap.set('n', '<leader>xr', '<cmd>Trouble lsp_references toggle<cr>', { desc = 'LSP References (Trouble)' })

-- ── Fidget: quiet LSP progress spinner in the corner ────────────────────────
-- Replaces noice's sometimes-noisy LSP progress messages.
require('fidget').setup {
  progress = {
    suppress_on_insert = true,   -- hide while typing
    ignore_done_already = true,
    display = {
      render_limit = 4,
      done_ttl = 2,
    },
  },
  notification = {
    window = {
      winblend = 0,
      border = 'none',
      align = 'bottom',
    },
  },
}

-- ── illuminate: highlight all occurrences of word under cursor ──────────────
require('illuminate').configure {
  delay = 200,
  under_cursor = true,
  large_file_cutoff = 2000,
  providers = { 'lsp', 'treesitter', 'regex' },
  filetypes_denylist = { 'neo-tree', 'TelescopePrompt', 'alpha', 'mason', 'help' },
}

-- Navigate between references with ]] / [[
vim.keymap.set('n', ']]', function() require('illuminate').goto_next_reference() end, { desc = 'Next reference' })
vim.keymap.set('n', '[[', function() require('illuminate').goto_prev_reference() end, { desc = 'Prev reference' })

-- ── which-key: keybind hint popups ──────────────────────────────────────────
require('which-key').setup {
  delay = 500,
  icons = { mappings = true },
  spec = {
    { '<leader>c', group = '[C]ode' },
    { '<leader>d', group = '[D]ebug' },
    { '<leader>e', group = '[E]xplorer' },
    { '<leader>f', group = '[F]ile' },
    { '<leader>g', group = '[G]it' },
    { '<leader>n', group = '[N]oice' },
    { '<leader>p', group = '[P]roject/session' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]erminal' },
    { '<leader>w', group = '[W]indow' },
    { '<leader>x', group = 'Trouble/[X] diagnostics' },
    { '<leader>z', group = '[Z]en' },
  },
}
