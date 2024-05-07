---@class ColorMark
---@field mark_ids number[]
---@field hl_group string

---@class MarkDataContainer
---@field marks { [string]: ColorMark }
--
---@alias BufferMarkDataContainer { [number]: MarkDataContainer }
local M = {
  _buffer_marks = {}, ---@type BufferMarkDataContainer
  _current_color_index = 1,
  default_colors = {}
}

local hl_groups = {
  "@text.warning",
  "@text.todo",
  "@text.note",
  "@text.danger",
}

local colorize_namespace = vim.api.nvim_create_namespace('ColorizeNamespace')

---@param bufnr buffer
---@param pattern string
---@param hl_group string
---@return number[]
local function build_extmarks(bufnr, pattern, hl_group)
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true) or {} ---@type string[]
  local results = {} ---@type number[]
  for i, line in ipairs(content) do
    local start = nil
    local stop = 0 ---@type integer?
    while true do
      -- use this instead
      start, stop = unpack(vim.fn.matchstrpos(line, pattern, stop + 1) or {}, 2, 3)
      if start < 0 or stop < 0 then
        break
      end
      results[#results + 1] = vim.api.nvim_buf_set_extmark(bufnr, colorize_namespace, i - 1, start, {
        end_col = stop,
        end_row = i - 1,
        hl_group = hl_group
      })
    end
  end
  return results
end

---@param word string
---@param hl_group? string
---@param bufnr? buffer
function M.colorize(word, hl_group, bufnr)
  assert(word ~= nil)
  if bufnr == 0 or bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if hl_group == nil then
    hl_group = hl_groups[M._current_color_index]
    M._current_color_index = (M._current_color_index % #hl_groups) + 1
  end

  local data = M._buffer_marks[bufnr] or { marks = {} }
  M._buffer_marks[bufnr] = data
  local marks = data.marks[word]
  if marks ~= nil then
    M.clear(bufnr, word)
  end
  marks = {
    mark_ids = build_extmarks(bufnr, word, hl_group),
    hl_group = hl_group,
  }

  data.marks[word] = marks
end

---@param bufnr? buffer
---@param pattern? string
---@overload fun(pattern: string)
function M.clear(bufnr, pattern)
  if type(bufnr) == "string" then
    pattern = bufnr
    bufnr = nil
  end
  if bufnr == nil or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local data = M._buffer_marks[bufnr]

  if data == nil then return end

  local mark_ctrs = data.marks

  if pattern == nil then
    for key, patterns in pairs(mark_ctrs) do
      for _, mark in pairs(patterns.mark_ids) do
        vim.api.nvim_buf_del_extmark(bufnr, colorize_namespace, mark)
      end
      mark_ctrs[key].mark_ids = {}
    end
  else
    local marks = mark_ctrs[pattern]
    if marks == nil then return end

    for _, mark in pairs(mark_ctrs.mark_ids) do
      vim.api.nvim_buf_del_extmark(bufnr, colorize_namespace, mark)
    end
    mark_ctrs[pattern].mark_ids = {}
  end
end

---@param bufnr buffer
function M.redraw(bufnr)
  local buf_data = M._buffer_marks[bufnr]
  if buf_data == nil then return end

  vim.api.nvim_buf_clear_namespace(bufnr, colorize_namespace, 0, -1)
  for pattern, color_mark in pairs(buf_data.marks) do
    for _, mark in pairs(color_mark.mark_ids) do
      vim.api.nvim_buf_del_extmark(bufnr, colorize_namespace, mark)
    end
    build_extmarks(bufnr, pattern, color_mark.hl_group)
  end
end

vim.api.nvim_create_user_command('Colorize', function(opt)
  local hl = nil
  local word = '\\V\\<' .. vim.fn.escape(vim.fn.expand("<cword>"), '\\') .. '\\>'
  if opt.args ~= '' then
    hl = opt.args
  end
  M.colorize(word, hl)
end, {
  nargs = '?',
  desc = 'Apply color to the word under the cursor',
  complete = 'highlight'
})

vim.api.nvim_create_user_command('ColorizeClear', function()
  M.clear()
end, {
  nargs = 0,
  desc = 'Remove colors from the current buffer'
})

vim.keymap.set('n', '<leader>xx', '<cmd>Colorize<cr>')
vim.keymap.set('n', '<leader>xc', '<cmd>ColorizeClear<cr>')
vim.keymap.set('v', '<leader>xx', function()
  local sel = require 'utility'.get_visual_selection()
  sel = '\\V' .. vim.fn.escape(sel, '\\')
  M.colorize(sel, nil)
end)

vim.api.nvim_create_autocmd('BufModifiedSet', {
  callback = function(opts)
    M.redraw(opts.buf)
  end
})

return M
