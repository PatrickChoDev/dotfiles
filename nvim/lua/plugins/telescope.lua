local builtin = require 'telescope.builtin'

-- rg-based find_files: respects .gitignore by default, toggle with C-h inside picker
local rg_find_cmd = { 'rg', '--files', '--hidden', '--glob', '!.git' }
local rg_find_cmd_no_ignore = { 'rg', '--files', '--hidden', '--no-ignore', '--glob', '!.git' }

local function find_files_with_toggle(no_ignore)
  builtin.find_files {
    find_command = no_ignore and rg_find_cmd_no_ignore or rg_find_cmd,
    prompt_title = no_ignore and 'Find Files (no .gitignore)' or 'Find Files',
    attach_mappings = function(prompt_bufnr, map)
      map({ 'i', 'n' }, '<C-h>', function()
        require('telescope.actions').close(prompt_bufnr)
        find_files_with_toggle(not no_ignore)
      end)
      return true
    end,
  }
end

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-k>'] = require('telescope.actions').move_selection_previous,
        ['<C-j>'] = require('telescope.actions').move_selection_next,
        ['<C-l>'] = require('telescope.actions').select_default,
      },
    },
    -- respects .gitignore; add --no-ignore to override
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob',
      '!.git',
    },
  },
  pickers = {
    live_grep = {
      additional_args = { '--hidden', '--glob', '!.git' },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    resession = {
      prompt_title = 'Find Sessions',
      dir = 'session',
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

-- File finding (C-h inside picker toggles .gitignore)
vim.keymap.set('n', '<leader><space>', function()
  find_files_with_toggle(false)
end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>ff', function()
  find_files_with_toggle(false)
end, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ile [R]ecent' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })

-- Visual mode: search selected text
local function get_visual_selection()
  local text = vim.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = 'v' })
  return table.concat(text, '\n')
end

vim.keymap.set('v', '<leader>sw', function()
  builtin.grep_string { search = get_visual_selection() }
end, { desc = '[S]earch selected [W]ord (exact)' })

vim.keymap.set('v', '<leader>sg', function()
  builtin.live_grep { default_text = get_visual_selection() }
end, { desc = '[S]earch [G]rep from selection' })

-- Search / grep
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch [G]rep everywhere' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[S]earch [T]reesitter symbols' })
vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = '[S]earch [Q]uickfix' })
vim.keymap.set('n', '<leader>s?', builtin.builtin, { desc = '[S]earch Telescope builtins' })

-- Git pickers
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('n', '<leader>gS', builtin.git_status, { desc = '[G]it [S]tatus (telescope)' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles' })

-- Buffer fuzzy search
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>ss', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]earch [S]ymbols (workspace)' })
