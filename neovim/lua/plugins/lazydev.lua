local gh = require('utils').gh

vim.pack.add { gh 'folke/lazydev.nvim' }
require('lazydev').setup {
  -- NOTE: idk if this is correctly configured or not.
  --
  library = {
    --   { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    --   { path = '${3rd}/busted/library', words = { 'describe', 'it', 'before_each', 'after_each' } },
    { path = 'nvim-lspconfig', words = { 'lspconfig' } },
  },
}

-- vim: ts=2 sts=2 sw=2 et
