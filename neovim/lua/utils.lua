-- Stolen shaamelessly from idr4n
local M = {}

local function get_cwd()
  local function realpath(path)
    if path == '' or path == nil then return nil end
    return vim.loop.fs_realpath(path) or path
  end

  return realpath(vim.loop.cwd()) or ''
end

local function get_capitalized_path(expand_str)
  local path = vim.fn.expand(expand_str)

  return path:gsub('^%a', string.upper)
end

---@return fun():string
function M.pretty_dirpath()
  return function()
    -- local path = vim.fn.expand '%:p' --[[@as string]]
    -- Keeping cause idk whether get_cwd can have lowercase
    -- as well
    local path = get_capitalized_path '%:p'

    if path == '' then return '' end
    local cwd = get_cwd()

    if path:find(cwd, 1, true) == 1 then path = path:sub(#cwd + 2) end

    local sep = '/'
    local parts = vim.split(path, '[\\/]')
    table.remove(parts)
    if #parts > 3 then parts = { parts[1], '...', parts[#parts - 1], parts[#parts] } end

    return #parts > 0 and (table.concat(parts, sep)) or '.'
  end
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
function M.gh(repo) return 'https://github.com/' .. repo end

return M

-- vim: ts=2 sts=2 sw=2 et
