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

  -- macOS-style navigation (works in normal + insert mode)
  -- Home/End (Cmd+← / Cmd+→ or physical Home/End keys)
  vim.keymap.set({ 'n', 'v' }, '<Home>', '^', opts)       -- first non-blank
  vim.keymap.set({ 'n', 'v' }, '<End>', '$', opts)
  vim.keymap.set('i', '<Home>', '<C-o>^', opts)
  vim.keymap.set('i', '<End>', '<End>', opts)              -- keep insert-mode End natural

  -- Word jump (Option+← / Option+→ — terminals send <M-b>/<M-f> or <C-Left>/<C-Right>)
  vim.keymap.set('n', '<C-Left>', 'b', opts)
  vim.keymap.set('n', '<C-Right>', 'w', opts)
  vim.keymap.set('i', '<C-Left>', '<C-o>b', opts)
  vim.keymap.set('i', '<C-Right>', '<C-o>w', opts)
  vim.keymap.set('n', '<M-b>', 'b', opts)
  vim.keymap.set('n', '<M-f>', 'w', opts)
  vim.keymap.set('i', '<M-b>', '<C-o>b', opts)
  vim.keymap.set('i', '<M-f>', '<C-o>w', opts)

  -- Page up/down (Fn+↑/↓ or physical PgUp/PgDn) — centered like C-d/C-u
  vim.keymap.set({ 'n', 'v' }, '<PageUp>', '<C-b>zz', opts)
  vim.keymap.set({ 'n', 'v' }, '<PageDown>', '<C-f>zz', opts)
  vim.keymap.set('i', '<PageUp>', '<C-o><C-b>', opts)
  vim.keymap.set('i', '<PageDown>', '<C-o><C-f>', opts)

  -- Shift+arrow: visual selection (normal mode only — insert mode isn't worth it)
  vim.keymap.set('n', '<S-Right>', 'vl', opts)
  vim.keymap.set('n', '<S-Left>', 'vh', opts)
  vim.keymap.set('n', '<S-Up>', 'Vk', opts)
  vim.keymap.set('n', '<S-Down>', 'Vj', opts)
  -- Extend selection in visual mode
  vim.keymap.set('v', '<S-Right>', 'l', opts)
  vim.keymap.set('v', '<S-Left>', 'h', opts)
  vim.keymap.set('v', '<S-Up>', 'k', opts)
  vim.keymap.set('v', '<S-Down>', 'j', opts)

  -- Stay in indent mode
  vim.keymap.set('v', '<', '<gv', opts)
  vim.keymap.set('v', '>', '>gv', opts)

  -- Keep last yanked when pasting in visual mode
  vim.keymap.set('v', 'p', '"_dP', opts)
end

return M
