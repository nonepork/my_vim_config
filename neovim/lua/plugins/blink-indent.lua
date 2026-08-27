local gh = require('utils').gh

vim.pack.add { gh 'saghen/blink.indent' }
require('blink.indent').setup {
  mappings = {
    object_scope = '',
    object_scope_with_border = '',
  },
  static = {
    char = '▏',
  },
  scope = {
    char = '▏',
    highlights = { 'Special' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
