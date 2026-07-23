require('Comment').setup {}

local function can_comment()
  if vim.bo.buftype ~= '' then
    return false
  end
  local cs = vim.bo.commentstring
  return cs ~= '' and cs ~= '%s'
end

vim.keymap.set('n', '<C-/>', function()
  if not can_comment() then
    vim.notify('No comment support for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  require('Comment.api').toggle.linewise.current()
end, { desc = 'Toggle comment line' })

vim.keymap.set('v', '<C-/>', function()
  if not can_comment() then
    vim.notify('No comment support for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { desc = 'Toggle comment selection' })
