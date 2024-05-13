---@alias winid number
---@alias bufid number
---@alias autocmdid number

---@class Buffer
---@field id bufid
---@field get_lines fun(buf: Buffer, start: number?, stop: number?, strict: boolean?):string[]
---@field ilines fun(buf: Buffer, start: number?, stop: number?, strict: boolean?):fun():number, string
---@field lines string[]
---@field lines_event fun(buffer: Buffer, changedtick, firstline, lastline, linedata, more)
---@field changedtick_event fun(buffer: Buffer, changedtick)
---@field detach_event fun(buffer: Buffer)
---@field create_user_command fun(buffer: Buffer, name, command, opts...)
---@field del_user_command fun(buffer: Buffer, name)
---@field get_commands fun(buffer: Buffer, opts...)
---@field get_option fun(buffer: Buffer, name)
---@field set_option fun(buffer: Buffer, name, value)
---@field attach fun(buffer: Buffer, send_buffer, opts)
---@field call fun(buffer: Buffer, fun)
---@field del_keymap fun(buffer: Buffer, mode, lhs)
---@field del_mark fun(buffer: Buffer, name)
---@field del_var fun(buffer: Buffer, name)
---@field delete fun(buffer: Buffer, opts)
---@field detach fun(buffer: Buffer)
---@field get_changedtick fun(buffer: Buffer)
---@field get_keymap fun(buffer: Buffer, mode)
---@field get_mark fun(buffer: Buffer, name)
---@field get_name fun(buffer: Buffer)
---@field get_offset fun(buffer: Buffer, index)
---@field get_text fun(buffer: Buffer, start_row, start_col, end_row, end_col, opts)
---@field get_var fun(buffer: Buffer, name)
---@field is_loaded fun(buffer: Buffer)
---@field is_valid fun(buffer: Buffer)
---@field line_count fun(buffer: Buffer)
---@field set_keymap fun(buffer: Buffer, mode, lhs, rhs, opts...)
---@field set_lines fun(buffer: Buffer, start, end, strict_indexing, replacement)
---@field set_mark fun(buffer: Buffer, name, line, col, opts)
---@field set_name fun(buffer: Buffer, name)
---@field set_text fun(buffer: Buffer, start_row, start_col, end_row, end_col, replacement)
---@field set_var fun(buffer: Buffer, name, value)
---@field add_highlight fun(buffer: Buffer, ns_id, hl_group, line, col_start, col_end)
---@field clear_namespace fun(buffer: Buffer, ns_id, line_start, line_end)
---@field del_extmark fun(buffer: Buffer, ns_id, id)
---@field get_extmark_by_id fun(buffer: Buffer, ns_id, id, opts)
---@field get_extmarks fun(buffer: Buffer, ns_id, start, end, opts)
---@field set_extmark fun(buffer: Buffer, ns_id, line, col, opts...)

local M = {}
---@param id bufid
---@return Buffer
function M.make_new_buffer_object(id)
  local new_buf = {
    id = id
  }
  function new_buf.get_lines(buf, start, stop, strict)
    if start == nil then start = 0 end
    if stop == nil then stop = -1 end
    if strict == nil then strict = true end
    return vim.api.nvim_buf_get_lines(buf.id, start, stop, strict)
  end

  function new_buf.ilines(buf, start, stop, strict)
    local line_list = buf:get_lines(start, stop, strict)
    local i = 0
    local n = #line_list
    return function()
      i = i + 1
      if i <= n then
        return i, line_list[i]
      end
    end
  end

  return setmetatable(new_buf, {
    __index = function(bufobject, key)
      local func = 'nvim_buf_' .. key
      if vim.api[func] ~= nil then
        return function(...)
          return vim.api[func](bufobject.id, ...)
        end
      elseif key == 'lines' then
        return vim.api.nvim_buf_get_lines(bufobject.id, 0, -1, true)
      end
      return rawget(bufobject, key)
    end,
    __newindex = function()
      error("Buffer objects are readonly")
    end,
    __eq = function(left, right)
      local lid, rid = left.id, right.id
      if lid == 0 then
        lid = vim.api.nvim_get_current_buf()
      end
      if rid == 0 then
        rid = vim.api.nvim_get_current_buf()
      end
      return lid == rid
    end,
  })
end

---@class Window
---@field id winid
---@field buffer Buffer
---@field tie_to_buffer fun(self: Window): autocmdid
---@field quit_on_leave fun(self: Window): autocmdid
---@field get_option fun(self: Window, name)
---@field set_option fun(self: Window, name, value)
---@field call fun(self: Window, fun)
---@field close fun(self: Window, force)
---@field del_var fun(self: Window, name)
---@field get_buf fun(self: Window)
---@field get_cursor fun(self: Window)
---@field get_height fun(self: Window)
---@field get_number fun(self: Window)
---@field get_position fun(self: Window)
---@field get_tabpage fun(self: Window)
---@field get_var fun(self: Window, name)
---@field get_width fun(self: Window)
---@field hide fun(self: Window)
---@field is_valid fun(self: Window)
---@field set_buf fun(self: Window, buffer: Buffer)
---@field set_cursor fun(self: Window, pos)
---@field set_height fun(self: Window, height)
---@field set_hl_ns fun(self: Window, ns_id)
---@field set_var fun(self: Window, name, value)
---@field set_width fun(self: Window, width)
---@field get_config fun(self: Window)
---@field set_config fun(self: Window, config...)

local winobject_lookup = {
  buffer = function(winobj)
    return M.make_new_buffer_object(vim.api.nvim_win_get_buf(winobj.id))
  end,
}

---@param id winid
---@return Window
function M.make_new_win_object(id)
  local new_win = {
    id = id
  }
  function new_win.set_buf(winobj, buf)
    return vim.api.nvim_win_set_buf(winobj.id, buf.id)
  end

  function new_win.tie_to_buffer(self)
    assert(self ~= nil, 'tie_to_buffer() must be called on a Window object')
    return vim.api.nvim_create_autocmd({ 'BufUnload' }, {
      buffer = self.buffer.id,
      callback = function()
        vim.schedule(function() vim.api.nvim_win_close(self.id, true) end)
      end
    })
  end

  function new_win.quit_on_leave(self)
    assert(self ~= nil, 'quit_on_leave() must be called on a Window object')
    local my_id
    my_id = vim.api.nvim_create_autocmd({ 'WinLeave' }, {
      callback = function()
        if vim.api.nvim_get_current_win() == self.id then
        vim.api.nvim_del_autocmd(my_id)
          vim.api.nvim_win_close(self.id, true)
        end
      end
    })
  end

  return setmetatable(new_win, {
    __index = function(winobject, key)
      local predef = winobject_lookup[key]
      if predef ~= nil then
        return predef(winobject)
      end

      local func = 'nvim_win_' .. key
      if vim.api[func] ~= nil then
        return function(...)
          return vim.api[func](winobject.id, ...)
        end
      end
      return rawget(winobject, key)
    end,
    __newindex = function()
      error("Window objects are readonly")
    end,
    __eq = function(left, right)
      local lid, rid = left.id, right.id
      if lid == 0 then
        lid = vim.api.nvim_get_current_win()
      end
      if rid == 0 then
        rid = vim.api.nvim_get_current_win()
      end
      return lid == rid
    end,
  })
end

return M
