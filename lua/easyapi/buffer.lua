local detail = require 'easyapi.detail'

---@class BufferStatic: Buffer
---@field current Buffer
---@field alternate Buffer
---@field last Buffer
---@field list Buffer[]
---@field [number] Buffer
---@diagnostic disable-next-line: param-type-mismatch
Buffer = detail.make_new_buffer_object(nil)
local metatbl = getmetatable(Buffer)
setmetatable(Buffer, nil)
local backup_index = metatbl.__index
local getbuf = function(s)
  local b = vim.fn.bufnr(s, false)
  if b == nil or b < 0 then return nil end
  return detail.make_new_buffer_object(b)
end
local lookup = {
  current = function() return detail.make_new_buffer_object(vim.api.nvim_get_current_buf()) end,
  alternate = function() return getbuf('#') end,
  last = function() return getbuf('$') end,
  id = function() return vim.api.nvim_get_current_buf() end,
}
metatbl.__index = function(table, key)
  local found = lookup[key]
  if found ~= nil then
    return found()
  elseif type(key) == "number" then
    return getbuf(key)
  else
    return backup_index(table, key)
  end
end

---@param listed boolean?
---@param scratch boolean?
---@param content string[]?
---@return Buffer
---@overload fun(content: string[]): Buffer
function Buffer.new(listed, scratch, content)
  if type(listed) == 'table' then
    local b = detail.make_new_buffer_object(vim.api.nvim_create_buf(true, false))
    vim.api.nvim_buf_set_lines(b.id, 0, -1, true, listed)
    return b
  else
    if listed == nil then listed = true end
    if scratch == nil then scratch = false end

    local b = detail.make_new_buffer_object(vim.api.nvim_create_buf(listed, scratch))
    if content ~= nil then
      vim.api.nvim_buf_set_lines(b.id, 0, -1, true, content)
    end
    return b
  end
end

---@param content string[]?
---@return Buffer
function Buffer.temp(content)
  return Buffer.new(false, true, content)
end

setmetatable(Buffer, metatbl)
