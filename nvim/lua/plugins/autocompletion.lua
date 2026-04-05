require('blink.cmp').setup {
  keymap = {
    -- Tab: open menu when hidden, cycle to next item when visible
    -- Falls back to normal Tab (indent) when menu is not active
    ['<Tab>'] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_next()
        else
          return cmp.show()
        end
      end,
      'fallback',
    },
    ['<S-Tab>'] = {
      function(cmp)
        if cmp.is_visible() then return cmp.select_prev() end
      end,
      'fallback',
    },
    -- Arrow navigation
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    -- Enter accepts only if an item was explicitly selected (Tab/arrows);
    -- otherwise inserts a normal newline
    ['<CR>'] = { 'accept', 'fallback' },
    -- Dismiss menu
    ['<C-e>'] = { 'hide', 'fallback' },
    -- Documentation scroll
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = true },
    list = {
      selection = {
        -- Nothing is pre-selected when menu opens.
        -- You must Tab/arrow to an item before Enter accepts it.
        preselect = false,
        auto_insert = false,
      },
    },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
}
