-- Set up keymaps (lazy-require neo-tree on first use)
local function neotree_toggle_focus()
  require('core.utils.neotree').toggle_focus()
end
local function neotree_toggle()
  require('core.utils.neotree').toggle()
end
local function neotree_reveal()
  require('core.utils.neotree').reveal_current_file()
end

vim.keymap.set('n', '<leader>e', neotree_toggle_focus, { desc = '[E]xplorer toggle focus' })
vim.keymap.set('n', '<leader>ee', neotree_toggle, { desc = '[E]xplorer visibility' })
vim.keymap.set('n', '<leader>ef', neotree_reveal, { desc = '[E]xplorer [F]ind current file' })
vim.keymap.set('n', '<leader>er', neotree_reveal, { desc = '[E]xplorer [R]eveal current file' })
vim.keymap.set('n', '<leader>gs', ':Neotree float git_status<CR>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '\\', neotree_toggle_focus, { desc = 'Focus Neo-tree / previous buffer' })
vim.keymap.set('n', '<leader>ngs', ':Neotree float git_status<CR>', { desc = 'Neo-tree git status' })

require('window-picker').setup {
  filter_rules = {
    include_current_win = false,
    autoselect_one = true,
    bo = {
      filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
      buftype = { 'terminal', 'quickfix' },
    },
  },
}

require('neo-tree').setup {
  popup_border_style = 'single',
  enable_git_status = true,
  enable_diagnostics = true,
  enable_cursor_hijack = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = '│',
      last_indent_marker = '└',
      highlight = 'NeoTreeIndentMarker',
      with_expanders = nil,
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '󰜌',
      folder_empty_open = '󰜌',
      use_filtered_colors = true,
      default = '*',
      highlight = 'NeoTreeFileIcon',
    },
    modified = { symbol = '[+]', highlight = 'NeoTreeModified' },
    name = { trailing_slash = false, use_git_status_colors = true, highlight = 'NeoTreeFileName' },
    git_status = {
      symbols = {
        added = '',
        modified = '',
        deleted = '',
        renamed = '󰁕',
        untracked = '',
        ignored = '',
        unstaged = '',
        staged = '',
        conflict = '',
      },
    },
    file_size = { enabled = true, required_width = 64 },
    type = { enabled = true, required_width = 122 },
    last_modified = { enabled = true, required_width = 88 },
    created = { enabled = true, required_width = 110 },
    symlink_target = { enabled = false },
  },
  window = {
    position = 'float',
    popup = {
      size = { height = '80%', width = '70%' },
      position = { row = '50%', col = '50%' },
    },
    mapping_options = { noremap = true, nowait = true },
    mappings = {
      ['<2-LeftMouse>'] = 'open',
      ['<cr>'] = 'open',
      ['<esc>'] = 'cancel',
      ['P'] = { 'toggle_preview', config = { use_float = true } },
      ['l'] = 'open',
      ['S'] = 'open_split',
      ['s'] = 'open_vsplit',
      ['t'] = 'open_tabnew',
      ['w'] = 'open_with_window_picker',
      ['C'] = 'close_node',
      ['z'] = 'close_all_nodes',
      ['Z'] = 'expand_all_nodes',
      ['a'] = { 'add', config = { show_path = 'none' } },
      ['A'] = 'add_directory',
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['y'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['c'] = 'copy',
      ['m'] = 'move',
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
      ['<'] = 'prev_source',
      ['>'] = 'next_source',
      ['i'] = 'show_file_details',
    },
  },
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      hide_by_name = {
        '.DS_Store',
        'thumbs.db',
        'node_modules',
        '__pycache__',
        '.virtual_documents',
        '.git',
        '.python-version',
        '.venv',
        '.jj',
      },
      never_show = { '.DS_Store', 'thumbs.db' },
    },
    follow_current_file = { enabled = true, leave_dirs_open = true },
    group_empty_dirs = false,
    hijack_netrw_behavior = 'open_default',
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ['<bs>'] = 'navigate_up',
        ['.'] = 'set_root',
        ['H'] = 'toggle_hidden',
        ['/'] = 'fuzzy_finder',
        ['D'] = 'fuzzy_finder_directory',
        ['f'] = 'filter_on_submit',
        ['<c-x>'] = 'clear_filter',
        ['[g'] = 'prev_git_modified',
        [']g'] = 'next_git_modified',
        ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
        ['oc'] = { 'order_by_created', nowait = false },
        ['od'] = { 'order_by_diagnostics', nowait = false },
        ['og'] = { 'order_by_git_status', nowait = false },
        ['om'] = { 'order_by_modified', nowait = false },
        ['on'] = { 'order_by_name', nowait = false },
        ['os'] = { 'order_by_size', nowait = false },
        ['ot'] = { 'order_by_type', nowait = false },
      },
      fuzzy_finder_mappings = {
        ['<down>'] = 'move_cursor_down',
        ['<C-n>'] = 'move_cursor_down',
        ['<up>'] = 'move_cursor_up',
        ['<C-p>'] = 'move_cursor_up',
      },
    },
    commands = {},
  },
  buffers = {
    follow_current_file = { enabled = true, leave_dirs_open = true },
    group_empty_dirs = true,
    show_unloaded = true,
    window = {
      mappings = {
        ['bd'] = 'buffer_delete',
        ['<bs>'] = 'navigate_up',
        ['.'] = 'set_root',
        ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
        ['oc'] = { 'order_by_created', nowait = false },
        ['od'] = { 'order_by_diagnostics', nowait = false },
        ['om'] = { 'order_by_modified', nowait = false },
        ['on'] = { 'order_by_name', nowait = false },
        ['os'] = { 'order_by_size', nowait = false },
        ['ot'] = { 'order_by_type', nowait = false },
      },
    },
  },
  git_status = {
    window = {
      position = 'float',
      popup = { size = { height = '60%', width = '80%' }, position = { row = '50%', col = '50%' } },
      mappings = {
        ['A'] = 'git_add_all',
        ['gu'] = 'git_unstage_file',
        ['ga'] = 'git_add_file',
        ['gr'] = 'git_revert_file',
        ['gc'] = 'git_commit',
        ['gp'] = 'git_push',
        ['gg'] = 'git_commit_and_push',
        ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
        ['oc'] = { 'order_by_created', nowait = false },
        ['od'] = { 'order_by_diagnostics', nowait = false },
        ['om'] = { 'order_by_modified', nowait = false },
        ['on'] = { 'order_by_name', nowait = false },
        ['os'] = { 'order_by_size', nowait = false },
        ['ot'] = { 'order_by_type', nowait = false },
      },
    },
  },
  event_handlers = {
    {
      event = 'neo_tree_root_changed',
      handler = function()
        local ok, title = pcall(require, 'core.title')
        if ok and title.update then
          title.update()
        end
      end,
    },
    {
      event = 'neo_tree_buffer_enter',
      handler = function()
        local ok, title = pcall(require, 'core.title')
        if ok and title.update then
          title.update()
        end
      end,
    },
  },
}
