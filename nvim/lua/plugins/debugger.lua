local dap = require 'dap'
local dapui = require 'dapui'

-- Keymaps (lazy-require dap on first trigger)
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
  require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint condition' })
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug [U]I toggle' })
vim.keymap.set('n', '<leader>dc', function() require('dap').terminate() end, { desc = '[D]ebug [C]lose/terminate session' })
vim.keymap.set('n', '<leader>dr', function() require('dap').run_last() end, { desc = '[D]ebug [R]un last' })

require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = { 'delve', 'debugpy', 'js-debug-adapter', 'codelldb' },
}

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸', play = '▶', step_into = '⏎', step_over = '⏭',
      step_out = '⏮', step_back = 'b', run_last = '▶▶', terminate = '⏹', disconnect = '⏏',
    },
  },
}

vim.api.nvim_set_hl(0, 'DapBreak', { link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, 'DapStop', { link = 'DiagnosticOk' })

local breakpoint_icons = {
  Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '',
  LogPoint = '', Stopped = '',
}
local priority_map = {
  Breakpoint = 60, BreakpointCondition = 60, BreakpointRejected = 60, LogPoint = 58, Stopped = 65,
}
for type, icon in pairs(breakpoint_icons) do
  local name = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStopped' or 'DapBreakpoint'
  vim.fn.sign_define(name, { text = icon, texthl = hl, numhl = hl, priority = priority_map[type] or 55 })
end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('dap-go').setup { delve = { detached = vim.fn.has 'win32' == 0 } }

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port
    cb { type = 'server', port = port, host = (config.connect or config).host or '127.0.0.1' }
  else
    cb {
      type = 'executable',
      command = vim.fn.exepath 'debugpy-adapter' ~= '' and vim.fn.exepath 'debugpy-adapter' or 'python',
      args = config.request == 'launch' and {} or { '-m', 'debugpy.adapter' },
    }
  end
end
dap.configurations.python = {
  {
    type = 'python', request = 'launch', name = 'Launch file', program = '${file}',
    pythonPath = function()
      local venv = vim.fn.getcwd() .. '/.venv/bin/python'
      return vim.fn.executable(venv) == 1 and venv or vim.fn.exepath 'python3' or 'python'
    end,
  },
}

local codelldb_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb'
dap.adapters.codelldb = {
  type = 'server', port = '${port}',
  executable = { command = codelldb_path, args = { '--port', '${port}' } },
}
for _, lang in ipairs { 'c', 'cpp', 'rust' } do
  dap.configurations[lang] = {
    {
      type = 'codelldb', request = 'launch', name = 'Launch executable',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}', stopOnEntry = false,
    },
    {
      type = 'codelldb', request = 'attach', name = 'Attach to process',
      pid = require('dap.utils').pick_process, cwd = '${workspaceFolder}',
    },
  }
end

dap.adapters['pwa-node'] = {
  type = 'server', host = 'localhost', port = '${port}',
  executable = {
    command = 'node',
    args = { vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
  },
}
for _, lang in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
  dap.configurations[lang] = {
    { type = 'pwa-node', request = 'launch', name = 'Launch file', program = '${file}', cwd = '${workspaceFolder}' },
    {
      type = 'pwa-node', request = 'attach', name = 'Attach to process',
      processId = require('dap.utils').pick_process, cwd = '${workspaceFolder}',
    },
  }
end
