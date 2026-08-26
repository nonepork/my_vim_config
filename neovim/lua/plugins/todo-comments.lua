local gh = require('utils').gh

vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- vim: ts=2 sts=2 sw=2 et
