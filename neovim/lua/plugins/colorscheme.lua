local gh = require('utils').gh

vim.pack.add { gh 'vague-theme/vague.nvim' }
require('vague').setup {
  transparent = true,
}

-- vim.pack.add { gh 'folke/tokyonight.nvim' }
-- ---@diagnostic disable-next-line: missing-fields
-- require('tokyonight').setup {
--   styles = {
--     comments = { italic = false },
--   },
-- }

-- vim.pack.add { gh 'noisesfromspace/touchup.nvim' }
-- require('touchup').setup()

-- vim.pack.add { 'https://github.com/oskarnurm/koda.nvim' }
-- require('koda').setup {transparent = false,}

-- vim: ts=2 sts=2 sw=2 et
