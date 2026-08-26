local gh = require('utils').gh

vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- vim: ts=2 sts=2 sw=2 et
