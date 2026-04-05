local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
require('fortune').setup()

dashboard.section.header.val = {
  [[.______      ___   .___________..______       __    ______  __  ___   ______  __    __    ______    _______   ___________    ____]],
  [[|   _  \    /   \  |           ||   _  \     |  |  /      ||  |/  /  /      ||  |  |  |  /  __  \  |       \ |   ____\   \  /   /]],
  [[|  |_)  |  /  ^  \ `---|  |----`|  |_)  |    |  | |  ,----'|  '  /  |  ,----'|  |__|  | |  |  |  | |  .--.  ||  |__   \   \/   / ]],
  [[|   ___/  /  /_\  \    |  |     |      /     |  | |  |     |    <   |  |     |   __   | |  |  |  | |  |  |  ||   __|   \      /  ]],
  [[|  |     /  _____  \   |  |     |  |\  \----.|  | |  `----.|  .  \  |  `----.|  |  |  | |  `--'  | |  '--'  ||  |____   \    /   ]],
  [[| _|    /__/     \__\  |__|     | _| `._____||__|  \______||__|\__\  \______||__|  \__|  \______/  |_______/ |_______|   \__/    ]],
}

dashboard.section.buttons.val = {
  dashboard.button('f', '󰈞    Find file', ':Telescope find_files <CR>'),
  dashboard.button('r', '    Recent files', ':Telescope oldfiles <CR>'),
  dashboard.button('s', '    Search text', ':Telescope live_grep <CR>'),
  dashboard.button('p', '    Projects', function()
    require('telescope').extensions.resession.resession()
  end),
  dashboard.button('c', '    Config', ':e $MYVIMRC <CR>'),
  dashboard.button('u', '  Update plugins', ':lua vim.pack.update()<CR>'),
  dashboard.button('m', '    Mason', ':Mason<CR>'),
  dashboard.button('q', '    Quit', ':qa<CR>'),
}

local fortune = require('fortune').get_fortune()

local date_section = {
  type = 'text',
  val = '󰸗 ' .. os.date '%Y-%m-%d %H:%M:%S',
  opts = { position = 'center', hl = 'EcovimHeaderInfo' },
}

-- Update date every second after startup
local timer = vim.loop.new_timer()
local function update_date()
  date_section.val = '󰸗 ' .. os.date '%Y-%m-%d %H:%M:%S'
  pcall(vim.cmd.AlphaRedraw)
end
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    if vim.fn.argc(-1) == 0 then
      update_date()
      timer:start(1000, 1000, vim.schedule_wrap(update_date))
    end
  end,
})

dashboard.section.footer.val = fortune
dashboard.section.header.opts.hl = 'Type'
dashboard.section.buttons.opts.hl = 'Keyword'
dashboard.section.footer.opts.hl = 'Type'
dashboard.opts.opts.noautocmd = true

dashboard.config.layout = {
  { type = 'padding', val = math.floor(vim.fn.winheight(0) * 0.3) },
  dashboard.section.header,
  { type = 'padding', val = 2 },
  dashboard.section.buttons,
  { type = 'padding', val = 2 },
  date_section,
  { type = 'padding', val = 2 },
  dashboard.section.footer,
}

-- Only show dashboard when opening nvim with no arguments
if vim.fn.argc(-1) == 0 then
  alpha.setup(dashboard.opts)
end
