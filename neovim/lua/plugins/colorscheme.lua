local gh = require('utils').gh

vim.pack.add { gh 'vague-theme/vague.nvim' }
require('vague').setup {
  transparent = true,
}

-- vim: ts=2 sts=2 sw=2 et
