-- Main keymaps initialization module
-- This loads all keymap modules in a modular fashion

-- Set leader key first (before any keymaps are loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Load all keymap modules
local modules = {
  'core.keymaps.editor',
  'core.keymaps.buffer',
  'core.keymaps.window',
  'core.keymaps.tab',
  'core.keymaps.diagnostics',
}

for _, module in ipairs(modules) do
  local ok, mod = pcall(require, module)
  if ok and mod.setup then
    mod.setup()
  else
    vim.notify('Failed to load keymap module: ' .. module, vim.log.levels.ERROR)
  end
end
