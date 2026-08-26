local gh = require('utils').gh

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

-- vim: ts=2 sts=2 sw=2 et
