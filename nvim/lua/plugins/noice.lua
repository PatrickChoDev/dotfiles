require('noice').setup {
  lsp = {
    -- LSP progress handled by fidget.nvim
    progress = { enabled = false },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    -- Cap hover/signature docs so they don't fill the screen
    hover = {
      enabled = true,
      opts = { max_width = 80, max_height = 20 },
    },
    signature = {
      enabled = true,
      opts = { max_width = 80, max_height = 10 },
    },
  },
  presets = {
    bottom_search = true,       -- search bar at the bottom
    command_palette = true,     -- cmdline + popupmenu together
    long_message_to_split = true, -- big messages go to a split, not a float
    inc_rename = false,
    lsp_doc_border = true,
  },
  -- Route messages to avoid noisy popups
  routes = {
    -- Suppress "N lines written / yanked / deleted" noise
    { filter = { event = 'msg_show', kind = '', find = 'written' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = 'fewer lines' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = 'more lines' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = 'line less' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = '%d+L, %d+B' }, opts = { skip = true } },
    -- Suppress search count noise ("1/42")
    { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
    -- Send any remaining large messages to a split instead of a float
    { filter = { event = 'msg_show', min_height = 5 }, view = 'split' },
    -- Errors: show as a small persistent notification (not blocking)
    {
      filter = { event = 'notify', min_level = vim.log.levels.ERROR },
      view = 'notify',
      opts = { timeout = 8000 },
    },
    -- Warnings: brief toast
    {
      filter = { event = 'notify', min_level = vim.log.levels.WARN },
      view = 'notify',
      opts = { timeout = 4000 },
    },
    -- Info / debug: very brief, no intrusion
    {
      filter = { event = 'notify', min_level = vim.log.levels.INFO },
      view = 'mini',
      opts = { timeout = 2000 },
    },
  },
  views = {
    popupmenu = { relative = 'editor' },
    -- Small toast in the bottom-right corner for routine messages
    mini = {
      timeout = 2000,
      position = { row = -2, col = '100%' },
      size = { max_width = 50 },
      border = { style = 'none' },
      zindex = 60,
    },
    -- Notify view: compact, bottom-right
    notify = {
      position = { row = -2, col = '100%' },
      size = { max_width = 60, max_height = 8 },
      border = { style = 'rounded' },
      zindex = 60,
    },
  },
}

pcall(require('telescope').load_extension, 'noice')

vim.keymap.set('n', '<leader>nl', '<cmd>NoiceLast<cr>', { desc = 'Noice Last Message' })
vim.keymap.set('n', '<leader>nh', '<cmd>Telescope noice<cr>', { desc = 'Noice History' })
vim.keymap.set('n', '<leader>na', '<cmd>NoiceAll<cr>', { desc = 'Noice All' })
vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<cr>', { desc = 'Dismiss All' })

vim.keymap.set({ 'i', 'n', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true, desc = 'Scroll forward' })

vim.keymap.set({ 'i', 'n', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true, desc = 'Scroll backward' })
