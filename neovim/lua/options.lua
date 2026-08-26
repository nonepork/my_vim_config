-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Setting options ]]
--  See `:help vim.o`
--  For more options, you can see `:help option-list`

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.incsearch = true

vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.confirm = true
vim.o.wrap = true
vim.o.laststatus = 3

-- vim: ts=2 sts=2 sw=2 et
