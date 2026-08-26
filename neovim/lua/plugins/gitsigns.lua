local gh = require('utils').gh

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    -- NOTE: Why isn't lsp complaining
    add = { text = '▎' }, ---@diagnostic disable-line: missing-fields
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '▎' },
    untracked = { text = '▎' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
