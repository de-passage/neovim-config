local detail = require 'easyapi.detail'

---@class WindowStatic: Window
---@field current Window
---@field alternate Window
---@field last Window
---@field [number] Window
---@diagnostic disable-next-line: param-type-mismatch
Window = detail.make_new_win_object(nil)

local metatbl = getmetatable(Window)
setmetatable(Window, nil)

local backup_index = metatbl.__index
local getbuf = function(s)
  local winid = vim.fn.winnr(s)
  if winid == nil or winid < 0 then return nil end
  return detail.make_new_win_object(winid)
end
local lookup = {
  current = function() return detail.make_new_win_object(vim.api.nvim_get_current_win()) end,
  alternate = function() return getbuf('#') end,
  last = function() return getbuf('$') end,
  id = function() return vim.api.nvim_get_current_win() end,
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

---@param buffer Buffer
---@return Window
---@overload fun(content: string[])
function Window.horizontal_split(buffer)
  vim.cmd.split()
  local win = detail.make_new_win_object(vim.api.nvim_get_current_win())
  if buffer.id ~= nil then
    vim.api.nvim_win_set_buf(win.id, buffer.id)
  else
    local bufid = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(bufid, 0, -1, true, buffer)
    vim.api.nvim_win_set_buf(win.id, bufid)
  end
  return win
end

---@param buffer Buffer
---@return Window
---@overload fun(content: string[])
function Window.split(...) return Window.horizontal_split(...) end

---@param buffer Buffer
---@return Window
---@overload fun(content: string[])
function Window.vertical_split(buffer)
  vim.cmd.split()
  local win = detail.make_new_win_object(vim.api.nvim_get_current_win())
  if buffer ~= nil then
    if buffer.id ~= nil then
      vim.api.nvim_win_set_buf(win.id, buffer.id)
    else
      local bufid = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_lines(bufid, 0, -1, true, buffer)
      vim.api.nvim_win_set_buf(win.id, bufid)
    end
  end
  return win
end

---@param content string[]
---@param quit_on_leave boolean?
---@return Window
function Window.temp_horizontal_split(content, quit_on_leave)
  local buf = Buffer.temp(content)
  local win = Window.horizontal_split(buf)
  win:tie_to_buffer()
  if quit_on_leave then
    win:quit_on_leave()
  end
  return win
end

---@param content string[]
---@param quit_on_leave boolean?
---@return Window
function Window.temp_vertical_split(content, quit_on_leave)
  local buf = Buffer.temp(content)
  local win = Window.vertical_split(buf)
  win:tie_to_buffer()
  if quit_on_leave then
    win:quit_on_leave()
  end
  return win
end

---@param content string[]
---@param quit_on_leave boolean?
---@return Window
function Window.temp_split(content, quit_on_leave) return Window.temp_horizontal_split(content, quit_on_leave) end

setmetatable(Window, metatbl)
