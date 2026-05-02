-- nvim-treesitter (main branch, Neovim 0.12+)

local parsers = {
  'lua', 'python', 'javascript', 'typescript', 'vimdoc', 'vim', 'regex',
  'terraform', 'sql', 'dockerfile', 'toml', 'json', 'java', 'groovy', 'go',
  'gitignore', 'graphql', 'yaml', 'make', 'cmake', 'markdown', 'markdown_inline',
  'bash', 'tsx', 'css', 'html', 'rust',
}

-- Install missing parsers (skips already-installed ones)
local ts = require 'nvim-treesitter'
local installed = ts.get_installed()
local to_install = vim.tbl_filter(function(p)
  return not vim.tbl_contains(installed, p)
end, parsers)
if #to_install > 0 then
  ts.install(to_install)
end

-- Enable treesitter highlight + indentation on each buffer
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CoreTreesitter', { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Folding is handled by nvim-ufo (plugins/folding.lua).
