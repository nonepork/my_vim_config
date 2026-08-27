require 'options'
require 'keymaps'
require 'autocmds'
require 'pack'

---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

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

-- ============================================================
-- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  require 'kickstart.plugins.neo-tree'
  require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  -- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- require 'custom.plugins'

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

  vim.pack.add { gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    -- NOTE: idk if this is correctly configured or not.
    --
    -- library = {
    --   { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    --   { path = '${3rd}/busted/library', words = { 'describe', 'it', 'before_each', 'after_each' } },
    -- },
  }

  vim.pack.add { gh 'folke/trouble.nvim' }
  require('trouble').setup()

  -- NOTE: change this back once merged
  vim.pack.add { gh 'nonepork/pack-ui.nvim' }

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

  -- vim.pack.add { gh 'noisesfromspace/touchup.nvim' }
  -- require('touchup').setup()

  -- vim.pack.add { 'https://github.com/oskarnurm/koda.nvim' }
  -- require('koda').setup {transparent = false,}

  pcall(require('vim._core.ui2').enable, {})
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
