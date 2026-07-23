vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    require('noice').setup {
      lsp = {
        progress = { enabled = false }, -- handled by fidget.nvim
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
      routes = {
        { filter = { event = 'msg_show', kind = { '', 'echo', 'echomsg' } }, view = 'notify' },
        { filter = { event = 'msg_show', kind = 'return_prompt' }, view = 'notify' },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    }

    pcall(require('telescope').load_extension, 'noice')
  end,
})

vim.keymap.set('n', '<leader>nh', '<cmd>Noice<cr>', { desc = 'Noice History (all)' })
vim.keymap.set('n', '<leader>nl', '<cmd>NoiceLast<cr>', { desc = 'Noice Last Message' })
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
