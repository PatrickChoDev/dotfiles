return {
  'goolord/alpha-nvim',
  event = function()
    -- Only load dashboard when opening nvim without arguments
    if vim.fn.argc(-1) == 0 then
      return 'VimEnter'
    end
  end,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'rubiin/fortune.nvim'
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    require("fortune").setup()

    dashboard.section.header.val = {
      [[.______      ___   .___________..______       __    ______  __  ___   ______  __    __    ______    _______   ___________    ____]],
      [[|   _  \    /   \  |           ||   _  \     |  |  /      ||  |/  /  /      ||  |  |  |  /  __  \  |       \ |   ____\   \  /   /]],
      [[|  |_)  |  /  ^  \ `---|  |----`|  |_)  |    |  | |  ,----'|  '  /  |  ,----'|  |__|  | |  |  |  | |  .--.  ||  |__   \   \/   / ]],
      [[|   ___/  /  /_\  \    |  |     |      /     |  | |  |     |    <   |  |     |   __   | |  |  |  | |  |  |  ||   __|   \      /  ]],
      [[|  |     /  _____  \   |  |     |  |\  \----.|  | |  `----.|  .  \  |  `----.|  |  |  | |  `--'  | |  '--'  ||  |____   \    /   ]],
      [[| _|    /__/     \__\  |__|     | _| `._____||__|  \______||__|\__\  \______||__|  |__|  \______/  |_______/ |_______|   \__/    ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('f', '󰈞    Find file', ':Telescope find_files <CR>'),
      dashboard.button('r', '    Recent files', ':Telescope oldfiles <CR>'),
      dashboard.button('s', '    Search text', ':Telescope live_grep <CR>'),
      dashboard.button('p', '    Projects', ':AutoSession search<CR>'),
      dashboard.button('c', '    Config', ':e $MYVIMRC <CR>'),
      dashboard.button('l', '󰒲    Lazy', ':Lazy<CR>'),
      dashboard.button('m', '    Mason', ':Mason<CR>'),
      dashboard.button('q', '    Quit', ':qa<CR>'),
    }

    local fortune = require("fortune").get_fortune()

    local plugins_section = {
            type = "text",
            val = "⚡ Loading plugins...",
            opts = {
              position = "center",
              hl = "comment"
            }
          }

          local date_section = {
                  type = "text",
                  val = "󰸗 " .. os.date("%Y-%m-%d %H:%M:%S"),
                  opts = {
                    position = "center",
                    hl = "EcovimHeaderInfo"
                  }
                }

          -- Create a timer to update the date every second
          local timer = vim.loop.new_timer()

          local function update_date()
            date_section.val = "󰸗 " .. os.date("%Y-%m-%d %H:%M:%S")
            pcall(vim.cmd.AlphaRedraw)
          end

          vim.api.nvim_create_autocmd('User', {
                pattern = 'LazyVimStarted',
                desc = 'Start Alpha dashboard datetime timer',
                once = true,
                callback = function()
                  update_date()
                  timer:start(1000, 1000, vim.schedule_wrap(update_date))
                end,
              })

    vim.api.nvim_create_autocmd('User', {
          pattern = 'LazyVimStarted',
          desc = 'Add Alpha dashboard footer',
          once = true,
          callback = function()
            local stats = require('lazy').stats()
            local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
            plugins_section.val = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. " ms"
            pcall(vim.cmd.AlphaRedraw)
          end,
        })

    dashboard.section.footer.val = fortune

    dashboard.section.header.opts.hl = 'Type'
    dashboard.section.buttons.opts.hl = 'Keyword'
    dashboard.section.footer.opts.hl = 'Type'

    dashboard.opts.opts.noautocmd = true

    -- Center the dashboard vertically
    dashboard.config.layout = {
      { type = "padding", val = math.floor(vim.fn.winheight(0) * 0.3) },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 2 },
      plugins_section,
      date_section,
      { type = "padding", val = 2 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.opts)
  end,
}
