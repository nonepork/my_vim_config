local gh = require('utils').gh

-- Temporary adding undotree here, also shamelessly stolen from pawelgrzybek
-- vim.cmd.packadd { 'nvim.undotree' }
-- vim.keymap.set(
--   'n',
--   '<leader>u',
--   function()
--     require('undotree').open {
--       command = math.floor(vim.api.nvim_win_get_width(0) / 4) .. 'vnew',
--     }
--   end,
--   { desc = '[U]ndotree toggle' }
-- )
vim.pack.add { 'https://github.com/jiaoshijie/undotree' }
require('undotree').setup { position = 'right' }
vim.keymap.set('n', '<leader>u', require('undotree').toggle, { desc = '[U]ndotree toggle' })
-- NOTE: I really like the elegancy and simplicity of built-in undotree, gotta contribute
-- /figure out a way to implement diff for them

-- vim: ts=2 sts=2 sw=2 et
