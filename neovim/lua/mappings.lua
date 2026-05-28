-- [[ Keymaps ]]
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

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>qd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)', noremap = true, silent = true })
vim.keymap.set('n', '<leader>qt', '<cmd>Trouble todo toggle<cr>', { desc = 'Todo List (Trouble)', noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- TODO: make this better
vim.keymap.set('n', '<C-up>', '3<C-w>+', { desc = 'Increase vertical window height', noremap = true, silent = true })
vim.keymap.set('n', '<C-down>', '3<C-w>-', { desc = 'Decrease vertical window height', noremap = true, silent = true })
vim.keymap.set('n', '<C-left>', '3<C-w><', { desc = 'Decrease horizontal window height', noremap = true, silent = true })
vim.keymap.set('n', '<C-right>', '3<C-w>>', { desc = 'Increase horizontal window height', noremap = true, silent = true })

vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next tab', noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprev<CR>', { desc = 'Previous tab', noremap = true, silent = true })
vim.keymap.set('n', 'C', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local wins = vim.api.nvim_list_wins()

  -- Count how many windows are showing this buffer
  local buf_wins = {}
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == current_buf then
      table.insert(buf_wins, win)
    end
  end

  local total_wins = #wins
  local buf_win_count = #buf_wins

  if total_wins > 1 then
    if buf_win_count > 1 then
      -- Case 3: same buffer in multiple windows → close only window
      vim.cmd 'close'
    else
      -- Case 2: different buffers → close window + buffer
      vim.cmd 'bd'
    end
  else
    -- Case 1: single window → just delete buffer
    vim.cmd 'bd'
  end
end, { desc = 'Smart close buffer/window', noremap = true, silent = true })

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle nvim-tree', noremap = true, silent = true })
vim.keymap.set('n', '<leader>gi', '<cmd>GuessIndent<CR>', { desc = '[G]uess [I]ndent' })

vim.keymap.set('n', 'K', function() -- Stole from petter-tchirkov
  local is_diagnostic = require('misc').is_diagnostic()
  if is_diagnostic == true then
    return vim.diagnostic.open_float { scope = 'cursor', border = 'single' }
  else
    return vim.lsp.buf.hover { border = 'single' }
  end
end, { desc = 'Open docs/Show diagnostic in float' })

-- [[ Autocommands ]]
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
