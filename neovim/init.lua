require 'options'
require 'keymaps'
require 'autocmds'
require 'pack'

require 'plugins'
do
  -- [[ Installing and Configuring Plugins ]]

  -- vim.pack.add { gh 'folke/tokyonight.nvim' }
  -- ---@diagnostic disable-next-line: missing-fields
  -- require('tokyonight').setup {
  --   styles = {
  --     comments = { italic = false },
  --   },
  -- }
end
vim.cmd.colorscheme 'vague'

do
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  require 'kickstart.plugins.neo-tree'
  require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- require 'custom.plugins'

  -- vim.pack.add { gh 'noisesfromspace/touchup.nvim' }
  -- require('touchup').setup()

  -- vim.pack.add { 'https://github.com/oskarnurm/koda.nvim' }
  -- require('koda').setup {transparent = false,}

  pcall(require('vim._core.ui2').enable, {})
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
