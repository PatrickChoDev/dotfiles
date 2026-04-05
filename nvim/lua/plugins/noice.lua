require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
  views = {
    popupmenu = {
      relative = 'editor',
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
