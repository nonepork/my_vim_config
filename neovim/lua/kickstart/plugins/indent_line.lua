-- Add indentation guides even on blank lines

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {
  indent = { char = '│', tab_char = '│' },

  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    highlight = { 'Special' },
    priority = 500,
  },
}
