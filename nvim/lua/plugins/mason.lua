return {
  'mason-org/mason.nvim',
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonInstallAll',
    'MasonUpdate',
    'MasonUninstall',
    'MasonUninstallAll',
    'MasonLog',
  },
  opts = {
    ui = {
      icons = {
        package_installed = '',
        package_pending = '',
        package_uninstalled = '',
      },
    },
  },
}
