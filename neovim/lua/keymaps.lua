-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  NOTE: may I interest you in mini.move?
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<C-n>', '')

vim.keymap.set({ 'n', 'v' }, 'j', 'gj')
vim.keymap.set({ 'n', 'v' }, 'k', 'gk')

vim.keymap.set('n', 'ss', '<cmd>split<CR>', { desc = 'Split horizontally', noremap = true, silent = true })
vim.keymap.set('n', 'sv', '<cmd>vsplit<CR>', { desc = 'Split vertically', noremap = true, silent = true })

-- stolen from and-rs
vim.keymap.set('v', '<', "<gv<C-o>'<", { desc = 'Inner indent while remaining in visual mode' })
vim.keymap.set('v', '>', ">gv<C-o>'<", { desc = 'Outer indent while remaining in visual mode' })

-- greatest remap here
vim.keymap.set('x', 'p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, 'y', [["+y]])
vim.keymap.set('n', 'Y', [["+Y]])
vim.keymap.set({ 'n', 'v' }, 'd', [["_d]])

vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = true,
  severity_sort = true,
  float = { border = 'single', source = 'if_many' },
  underline = true,

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)', noremap = true, silent = true })
vim.keymap.set('n', '<leader>qt', '<cmd>Trouble todo toggle<cr>', { desc = 'Todo List (Trouble)', noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- NOTE: I use mouse to resize windows btw, I know I know but I can't help myself :p

vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next tab', noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprev<CR>', { desc = 'Previous tab', noremap = true, silent = true })

--  vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle nvim-tree', noremap = true, silent = true })
vim.keymap.set('n', '<leader>gi', '<cmd>GuessIndent<CR>', { desc = '[G]uess [I]ndent' })
-- NOTE: the K thingy seems to be built-in, so I just use ]d [d to show errors now, gotta
-- figure out a way to copy the errors though.

-- [[ Editorconfig custom properties ]]
local ok, editorconfig = pcall(require, 'editorconfig')
if ok then editorconfig.properties.commentstring = function(bufnr, val) vim.bo[bufnr].commentstring = val end end

-- vim: ts=2 sts=2 sw=2 et
