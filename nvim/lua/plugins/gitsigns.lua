require('gitsigns').setup {
  sign_priority = 100,
  on_attach = function(bufnr)
    local gs = require 'gitsigns'
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation
    map(']h', gs.next_hunk, 'Next git hunk')
    map('[h', gs.prev_hunk, 'Previous git hunk')

    -- Hunk operations
    map('<leader>ghs', gs.stage_hunk, '[G]it [H]unk [S]tage')
    map('<leader>ghr', gs.reset_hunk, '[G]it [H]unk [R]eset')
    map('<leader>ghS', gs.stage_buffer, '[G]it [H]unk stage buffer')
    map('<leader>ghp', gs.preview_hunk, '[G]it [H]unk [P]review')
    map('<leader>ghb', function() gs.blame_line { full = true } end, '[G]it [H]unk [B]lame line')
    map('<leader>ghd', gs.diffthis, '[G]it [H]unk [D]iff this')

    -- Visual mode: stage/reset selected hunk range
    vim.keymap.set('v', '<leader>ghs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { buffer = bufnr, desc = '[G]it [H]unk [S]tage (visual)' })
    vim.keymap.set('v', '<leader>ghr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { buffer = bufnr, desc = '[G]it [H]unk [R]eset (visual)' })
  end,
}
