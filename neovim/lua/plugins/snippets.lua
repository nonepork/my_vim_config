local gh = require('utils').gh

-- [[ Snippet Engine ]]

-- NOTE: You can also specify plugin using a version range for its git tag.
--  See `:help vim.version.range()` for more info
vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- https://github.com/rafamadriz/friendly-snippets
vim.pack.add { gh 'rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

-- vim: ts=2 sts=2 sw=2 et
