-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
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
end

-- ============================================================
-- SECTION 2: KEYMAPS
-- basic keymaps
-- ============================================================
do
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
  vim.keymap.set(
    'n',
    '<leader>qd',
    '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
    { desc = 'Buffer Diagnostics (Trouble)', noremap = true, silent = true }
  )
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

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      -- NOTE: Why isn't lsp complaining
      add = { text = '▎' }, ---@diagnostic disable-line: missing-fields
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
  }

  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- vim.pack.add { gh 'folke/tokyonight.nvim' }
  -- ---@diagnostic disable-next-line: missing-fields
  -- require('tokyonight').setup {
  --   styles = {
  --     comments = { italic = false },
  --   },
  -- }
  vim.pack.add { gh 'vague-theme/vague.nvim' }
  require('vague').setup {
    transparent = true,
  }
  vim.cmd.colorscheme 'vague'

  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
  end

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  require('mini.pairs').setup {
    modes = {
      insert = true,
      command = false,
      terminal = false,
    },
    skip_unbalanced = true,
    markdown = true,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  require('mini.surround').setup()

  require('mini.bufremove').setup()
  vim.keymap.set('n', 'C', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local wins = vim.api.nvim_list_wins()

    -- Count how many windows are showing this buffer
    local buf_wins = {}
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_get_buf(win) == current_buf then table.insert(buf_wins, win) end
    end

    local total_wins = #wins
    local buf_win_count = #buf_wins

    if total_wins > 1 then
      if buf_win_count > 1 then
        -- Case 3: same buffer in multiple windows → close only window
        vim.cmd 'close'
      else
        -- Case 2: different buffers → close window + buffer
        vim.cmd 'lua MiniBufremove.delete()'
      end
    else
      -- Case 1: single window → just delete buffer
      vim.cmd 'lua MiniBufremove.delete()'
    end
  end, { desc = 'Smart close buffer/window', noremap = true, silent = true })

  require('mini.splitjoin').setup()
  -- require('mini.indentscope').setup {
  --   symbol = '│',
  -- }

  local statusline = require 'mini.statusline'
  statusline.setup {
    use_icons = vim.g.have_nerd_font,
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
        local git = MiniStatusline.section_git { trunc_width = 40 }
        local diff = MiniStatusline.section_diff { trunc_width = 75 }
        local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
        local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
        local filename = MiniStatusline.section_filename { trunc_width = 140 }
        local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
        local location = MiniStatusline.section_location { trunc_width = 75 }
        local search = MiniStatusline.section_searchcount { trunc_width = 75 }

        return MiniStatusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=', -- End left alignment
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, diagnostics, lsp } },
          { hl = mode_hl, strings = { search, location } },
        }
      end,
    },
  }

  -- You can configure sections in the statusline by overriding their
  -- default behavior.
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_mode = function(args)
    local modes = {
      ['n'] = { long = 'NORMAL', short = 'N', hl = 'MiniStatuslineModeNormal' },
      ['v'] = { long = 'VISUAL', short = 'V', hl = 'MiniStatuslineModeVisual' },
      ['V'] = { long = 'V-LINE', short = 'V-L', hl = 'MiniStatuslineModeVisual' },
      [''] = { long = 'V-BLOCK', short = 'V-B', hl = 'MiniStatuslineModeVisual' },
      ['s'] = { long = 'SELECT', short = 'S', hl = 'MiniStatuslineModeVisual' },
      ['S'] = { long = 'S-LINE', short = 'S-L', hl = 'MiniStatuslineModeVisual' },
      [''] = { long = 'S-BLOCK', short = 'S-B', hl = 'MiniStatuslineModeVisual' },
      ['i'] = { long = 'INSERT', short = 'I', hl = 'MiniStatuslineModeInsert' },
      ['R'] = { long = 'REPLACE', short = 'R', hl = 'MiniStatuslineModeReplace' },
      ['c'] = { long = 'COMMAND', short = 'C', hl = 'MiniStatuslineModeCommand' },
      ['r'] = { long = 'PROMPT', short = 'P', hl = 'MiniStatuslineModeOther' },
      ['!'] = { long = 'SHELL', short = 'Sh', hl = 'MiniStatuslineModeOther' },
      ['t'] = { long = 'TERMINAL', short = 'T', hl = 'MiniStatuslineModeOther' },
    }

    local mode_code = vim.fn.mode()
    local mode_info = modes[mode_code] or { long = mode_code, short = mode_code, hl = 'MiniStatuslineModeOther' }
    local mode = statusline.is_truncated(args.trunc_width) and mode_info.short or mode_info.long

    return mode, mode_info.hl
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_filename = function(args)
    if vim.bo.buftype == 'terminal' then return '%t' end

    if vim.fn.expand '%' == '' then return '[no name]' end

    local utils = require 'utils'

    if statusline.is_truncated(args.trunc_width) then
      return '%t%m%r' -- Just filename when truncated
    else
      local dir = utils.pretty_dirpath()()
      local filename = vim.fn.expand '%:t'

      return dir .. '/' .. filename .. ' %m%r%h%w '
    end
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_git = function(args)
    if statusline.is_truncated(args.trunc_width) then return '' end

    local branch = vim.b.minigit_summary_string or vim.b.gitsigns_head

    if branch == nil or branch == '' then
      local use_icons = vim.g.have_nerd_font
      local icon = args.icon or (use_icons and '' or 'Git')
      return icon .. ' No branch'
    end

    if string.len(branch) > 20 then branch = branch:sub(1, 20) .. '...' end

    local use_icons = vim.g.have_nerd_font
    local icon = args.icon or (use_icons and '' or 'Git')
    return icon .. ' ' .. branch
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_diff = function(args)
    if statusline.is_truncated(args.trunc_width) then return '' end

    -- local statuses = vim.b.minidiff_summary
    -- NOTE: uncomment line above if you uses minidiff, and change the parameters' names
    local statuses = vim.b.gitsigns_status_dict
    if statuses == nil then return '' end

    local changes = statuses.changed or 0
    local additions = statuses.added or 0
    local deletions = statuses.removed or 0

    return ' ' .. '%#GitSignsChange#~' .. changes .. ' %#GitSignsAdd#+' .. additions .. ' %#GitSignsDelete#-' .. deletions .. '%*'
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_diagnostics = function(args)
    if statusline.is_truncated(args.trunc_width) then return '' end

    if not rawget(vim, 'lsp') then return '' end

    local get_diagnostic_count = function(severity)
      local count = vim.diagnostic.count(0, { severity = severity })[severity]
      return count or 0
    end

    local error_count = get_diagnostic_count(vim.diagnostic.severity.ERROR)
    local warning_count = get_diagnostic_count(vim.diagnostic.severity.WARN)
    local info_count = get_diagnostic_count(vim.diagnostic.severity.INFO)
    local hint_count = get_diagnostic_count(vim.diagnostic.severity.HINT)
    local infonhints_count = info_count + hint_count

    local parts = {}
    if error_count > 0 then table.insert(parts, '%#DiagnosticError#E' .. error_count .. '%*') end
    if warning_count > 0 then table.insert(parts, '%#DiagnosticWarn#W' .. warning_count .. '%*') end
    if infonhints_count > 0 then table.insert(parts, '%#DiagnosticHint#I' .. infonhints_count .. '%*') end
    if #parts == 0 then return '' end

    return table.concat(parts, ' ')
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_lsp = function(args)
    if statusline.is_truncated(args.trunc_width) then return '' end
    if #vim.lsp.get_clients { bufnr = 0 } == 0 then return '' end
    return 'LSP'
  end

  -- Updates statusline real-time when git signs updated
  vim.api.nvim_create_autocmd('User', {
    pattern = 'GitSignsUpdate',
    command = 'redrawstatus',
  })

  require('mini.comment').setup {
    mappings = {
      comment = '',
      comment_line = '<leader>/',
      comment_visual = '<leader>/',
    },
  }
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
  -- Two important keymaps to use while in Telescope are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?

  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
    gh 'catgoose/telescope-helpgrep.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  -- NOTE: You can install multiple plugins at once
  vim.pack.add(telescope_plugins)

  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    -- defaults = {
    --   mappings = {
    --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
    --   },
    -- },
    pickers = {
      help_tags = {
        mappings = {
          i = {
            ['<CR>'] = require('telescope.actions').select_vertical,
          },
        },
      },
    },
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
      helpgrep = {
        mappings = {
          i = {
            ['<CR>'] = require('telescope.actions').select_vertical,
          },
        },
      },
    },
  }

  -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'helpgrep')

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', function() builtin.builtin { include_extensions = true } end, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  -- If you later switch picker plugins, this is where to update these mappings.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Find references for the word under your cursor.
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Override default behavior and theme when searching
  vim.keymap.set('n', '<leader>sb', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = 'Fuzzily [s]earch in current [b]uffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set(
    'n',
    '<leader>s/',
    function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    { desc = '[S]earch [/] in Open Files' }
  )

  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Neovim(client) throws texts to an Language server(understand language), they both
  -- speaks LSP, and when user want to do something, nvim sends a request to the server
  -- and handles response.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {
    notification = {
      window = {
        winblend = 0,
        border = 'single',
      },
    },
  }

  --  This runs when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Hover hold highlights word autocommands
      -- See `:help CursorHold` for information about when this is executed
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  ---@type table<string, vim.lsp.Config>
  local servers = {
    stylua = {}, -- Used to format Lua code
    -- Special Lua Config, as recommended by neovim help docs
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            -- library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            --   '${3rd}/luv/library',
            --   '${3rd}/busted/library',
            -- }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- Disable formatting (formatting is done by stylua)
          telemetry = { enable = false }, -- Why is this a thing
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Automatically install LSPs and related tools to stdpath for Neovim
  require('mason').setup {}

  -- Ensure the servers and tools above are installed
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- You can add other tools here that you want Mason to install
    -- 'basedpyright',
    -- 'black',
    -- 'clangd',
    -- 'cssls',
    -- 'gopls',
    -- 'intelephense',
    -- 'isort',
    -- 'jsonls',
    -- 'prettierd',
    -- 'rust_analyzer',
    -- 'tailwindcss',
    -- 'ts_ls',
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    ensure_installed = {}, -- We use mason-tool-installer
    automatic_enable = true, -- Automatically run vim.lsp.enable() for all servers that are installed via Mason
  }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    -- vim.lsp.enable(name)
  end

  -- An alias for :checkhealth vim.lsp
  vim.api.nvim_create_user_command('LspInfo', function() vim.cmd 'checkhealth vim.lsp' end, { desc = 'Show information about lsps' })
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- You can specify filetypes to autoformat on save here:
      local enabled_filetypes = {
        lua = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      lua = { 'stylua' },
      css = { 'prettierd' },
      html = { 'prettierd' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      json = { 'prettierd' },
      markdown = { 'prettierd' },
      -- python = { 'isort', 'black' },
      python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>fm', function() require('conform').format { async = true } end, { desc = '[F]or[m]at buffer' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]

  -- NOTE: You can also specify plugin using a version range for its git tag.
  --  See `:help vim.version.range()` for more info
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- https://github.com/rafamadriz/friendly-snippets
  vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'enter',
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- NOTE: <c-space> conflicts with my terminal's leader

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
      list = { selection = { preselect = false } },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets' },
      -- NOTE: why isn't buffer used?
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  --  Used to highlight, edit, and navigate code
  --  See `:help nvim-treesitter-intro`

  -- NOTE: You can also specify a branch or a specific commit
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Ensure basic parsers are installed
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

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
  vim.cmd.packadd { 'nvim.undotree' }
  vim.keymap.set(
    'n',
    '<leader>u',
    function()
      require('undotree').open {
        command = math.floor(vim.api.nvim_win_get_width(0) / 4) .. 'vnew',
      }
    end,
    { desc = '[U]ndotree toggle' }
  )

  vim.pack.add { gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    -- NOTE: idk if this is correctly configured or not.
    --
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = '${3rd}/busted/library', words = { 'describe', 'it', 'before_each', 'after_each' } },
    },
  }

  vim.pack.add { gh 'folke/trouble.nvim' }
  require('trouble').setup()

  vim.pack.add { gh 'jtprogru/pack-ui.nvim' }

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

  require('vim._core.ui2').enable {}
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
