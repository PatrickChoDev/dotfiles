vim.opt.viewoptions = { 'folds', 'cursor' }

local fold_group = vim.api.nvim_create_augroup('PersistFolds', { clear = true })

local function valid_buf()
  return vim.bo.buftype == '' and vim.fn.expand '%' ~= ''
end

local function has_closed_folds()
  local line_count = vim.api.nvim_buf_line_count(0)
  for i = 1, line_count do
    if vim.fn.foldclosed(i) == i then return true end
  end
  return false
end

local function save_view()
  if not valid_buf() then return end
  if has_closed_folds() then
    pcall(vim.cmd, 'mkview')
  end
end

local function restore_view()
  if not valid_buf() then return end
  -- loadview silently fails (pcall) when no view file exists → all folds stay open
  pcall(vim.cmd, 'loadview')
end

-- Save only when there are closed folds; no view = no restore = all open
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = fold_group,
  pattern = '*',
  callback = save_view,
})

-- Defer so ufo finishes computing fold ranges before we apply saved state
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = fold_group,
  pattern = '*',
  callback = function()
    vim.defer_fn(restore_view, 150)
  end,
})

-- nvim-ufo: better fold display with line counts and peek
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

require('ufo').setup {
  -- Use LSP for capable filetypes, fall back to treesitter then indent
  provider_selector = function(_, filetype, _)
    local lsp_filetypes = { 'python', 'typescript', 'javascript', 'lua', 'rust', 'go', 'css', 'html' }
    if vim.tbl_contains(lsp_filetypes, filetype) then
      return { 'lsp', 'treesitter' }
    end
    return { 'treesitter', 'indent' }
  end,
  -- Show count of hidden lines in fold
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d lines'):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
  end,
}

-- Override fold keymaps to use ufo
vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with level' })
-- Peek fold content without jumping into it
vim.keymap.set('n', '<leader>zp', require('ufo').peekFoldedLinesUnderCursor, { desc = '[Z] [P]eek fold' })
