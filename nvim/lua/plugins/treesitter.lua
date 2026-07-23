-- nvim-treesitter (main branch, Neovim 0.12+)

-- Auto-install parser + enable highlight/indent for any filetype that has one.
-- Skip non-file buffers (UI panels, terminals, etc.) and known plugin pseudo-filetypes.
local skip_ft = {
  notify = true, ['neo-tree'] = true, ['neo-tree-popup'] = true,
  TelescopePrompt = true, TelescopeResults = true,
  lazy = true, mason = true, lspinfo = true,
  alpha = true, dashboard = true,
  qf = true, help = true, man = true,
  DiffviewFiles = true, DiffviewFileHistory = true,
  NeogitStatus = true, NeogitCommitMessage = true,
  dap = true, dapui_watches = true, dapui_stacks = true,
  dapui_breakpoints = true, dapui_scopes = true, dapui_console = true,
  fidget = true, noice = true, Trouble = true,
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CoreTreesitter', { clear = true }),
  callback = function(args)
    if vim.bo.buftype ~= '' or skip_ft[args.match] then return end
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang then
      pcall(function() require('nvim-treesitter').install({ lang }) end)
      pcall(vim.treesitter.start)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Folding is handled by nvim-ufo (plugins/folding.lua).
