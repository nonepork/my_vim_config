require 'options'
require 'keymaps'
require 'autocmds'
require 'pack'
require 'plugins'

pcall(require('vim._core.ui2').enable, {}) -- enabling new ui2 in neovim 0.12, see `:help ui2`
vim.cmd.colorscheme 'vague'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
