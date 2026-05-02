require('conform').setup {
  formatters_by_ft = {
    lua             = { 'stylua' },
    python          = { 'isort', 'black' },
    javascript      = { 'prettier' },
    typescript      = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    html            = { 'prettier' },
    css             = { 'prettier' },
    json            = { 'prettier' },
    yaml            = { 'prettier' },
    markdown        = { 'prettier' },
    sh              = { 'shfmt' },
    go              = { 'goimports', 'gofmt' },
    rust            = { 'rustfmt' },
    toml            = { 'taplo' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
