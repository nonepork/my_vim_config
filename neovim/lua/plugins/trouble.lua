local gh = require('utils').gh

vim.pack.add { gh 'folke/trouble.nvim' }
require('trouble').setup()

-- vim: ts=2 sts=2 sw=2 et
