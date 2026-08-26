local gh = require('utils').gh

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
vim.pack.add { gh 'nvim-treesitter/nvim-treesitter-textobjects' } -- For textobjects
require('mini.ai').setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  custom_textobjects = {
    f = require('mini.ai').gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    c = require('mini.ai').gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
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

  local ignore_filetypes = {
    ['help'] = true,
    ['atone'] = true,
  }

  -- quit directly if in lists
  if ignore_filetypes[vim.bo[current_buf].filetype] then
    vim.cmd 'q'
    return
  end

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
      MiniBufremove.delete()
    end
  else
    -- Case 1: single window → just delete buffer
    MiniBufremove.delete()
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

-- vim: ts=2 sts=2 sw=2 et
