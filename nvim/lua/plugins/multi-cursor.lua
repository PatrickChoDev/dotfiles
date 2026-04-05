-- Set globals before the plugin loads
vim.g.VM_default_mappings = 0
vim.g.VM_mouse_mappings = 1
vim.g.VM_leader = '\\\\'

vim.g.VM_maps = {
  ['Find Under'] = '<C-d>',
  ['Find Subword Under'] = '<C-d>',
  ['Add Cursor Down'] = '<C-Down>',
  ['Add Cursor Up'] = '<C-Up>',
  ['Add Cursor At Pos'] = '<C-LeftMouse>',
  ['Select All'] = '<C-S-l>',
  ['Select l'] = '<C-S-l>',
  ['Skip Region'] = 'q',
  ['Remove Region'] = 'Q',
  ['Visual Regex'] = '\\/',
  ['Visual All'] = '\\A',
  ['Visual Add'] = '\\a',
  ['Visual Find'] = '\\f',
  ['Visual Cursors'] = '\\c',
}

vim.g.VM_Mono_hl = 'DiffText'
vim.g.VM_Extend_hl = 'DiffAdd'
vim.g.VM_Cursor_hl = 'Visual'
vim.g.VM_Insert_hl = 'DiffChange'

vim.api.nvim_create_autocmd('User', {
  pattern = 'visual_multi_start',
  callback = function()
    vim.notify('Multi-cursor mode activated', vim.log.levels.INFO)
  end,
})
