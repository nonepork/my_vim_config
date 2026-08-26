local gh = require('utils').gh

vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {
  notification = {
    window = {
      winblend = 0,
      border = 'single',
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
