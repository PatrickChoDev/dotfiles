-- Editor-related keymaps (saving, editing, etc.)

local M = {}
local opts = { noremap = true, silent = true }

function M.setup()
  -- Save file
  vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', opts)
  vim.keymap.set('i', '<C-s>', '<cmd>w<CR>', opts)

  -- Save file without auto-formatting
  vim.keymap.set('n', '<leader>fn', '<cmd>noautocmd w<CR>', { noremap = true, silent = true, desc = '[F]ile save [N]o format' })

  -- Quit file
  vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', opts)

  -- Delete single character without copying into register
  vim.keymap.set('n', 'x', '"_x', opts)

  -- Vertical scroll and center
  vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
  vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

  -- Find and center
  vim.keymap.set('n', 'n', 'nzzzv', opts)
  vim.keymap.set('n', 'N', 'Nzzzv', opts)

  -- Clear search highlighting with Esc
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)

  -- Resize with arrows
  vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
  vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
  vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
  vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

  -- Toggle line wrapping
  vim.keymap.set('n', '<leader>Tw', '<cmd>set wrap!<CR>', { noremap = true, silent = true, desc = '[T]oggle [W]rap' })

  -- Stay in indent mode
  vim.keymap.set('v', '<', '<gv', opts)
  vim.keymap.set('v', '>', '>gv', opts)

  -- Keep last yanked when pasting in visual mode
  vim.keymap.set('v', 'p', '"_dP', opts)
end

return M
