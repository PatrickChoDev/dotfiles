return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
  init = function()
    -- Disable default mappings
    vim.g.VM_default_mappings = 0
    vim.g.VM_mouse_mappings = 1
    vim.g.VM_leader = '\\\\'

    -- Custom mappings (more VSCode-like)
    vim.g.VM_maps = {
      -- Find and select
      ['Find Under'] = '<C-d>', -- Ctrl+d like VSCode (select word under cursor and next occurrence)
      ['Find Subword Under'] = '<C-d>',

      -- Add cursor
      ['Add Cursor Down'] = '<C-Down>', -- Add cursor below
      ['Add Cursor Up'] = '<C-Up>', -- Add cursor above
      ['Add Cursor At Pos'] = '<C-LeftMouse>', -- Alt+Click equivalent (use Ctrl+Click)

      -- Select all occurrences
      ['Select All'] = '<C-S-l>', -- Select all occurrences of word (like Ctrl+Shift+L in VSCode)
      ['Select l'] = '<C-S-l>',

      -- Navigation
      ['Skip Region'] = 'q', -- Skip current and move to next
      ['Remove Region'] = 'Q', -- Remove current cursor

      -- Visual mode
      ['Visual Regex'] = '\\/', -- Start regex search
      ['Visual All'] = '\\A', -- Select all in visual selection
      ['Visual Add'] = '\\a', -- Add visual selection
      ['Visual Find'] = '\\f', -- Find in visual selection
      ['Visual Cursors'] = '\\c', -- Add cursor to each line in selection
    }

    -- Highlighting
    vim.g.VM_Mono_hl = 'DiffText'
    vim.g.VM_Extend_hl = 'DiffAdd'
    vim.g.VM_Cursor_hl = 'Visual'
    vim.g.VM_Insert_hl = 'DiffChange'
  end,
  config = function()
    -- Additional configuration after plugin loads
    vim.api.nvim_create_autocmd('User', {
      pattern = 'visual_multi_start',
      callback = function()
        vim.notify('Multi-cursor mode activated', vim.log.levels.INFO)
      end,
    })
  end,
}
