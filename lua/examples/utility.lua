local M = {}

-- find executables in the workspace data directory (intended to select files for nvim dap) 
function M.find_executable(callback)
    local err = ""
    local result = ""
    vim.fn.jobstart({ 'fd', '.', '-tx', '--no-ignore', '--hidden' }, {
      cwd = require 'workspace'.directory,
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        result = data
      end,
      on_stderr = function(_, data)
        err = data
      end,
      on_exit = function(_, code)
        if code ~= 0 then
          vim.notify(err, vim.log.levels.WARN)
          callback(nil, err)
        else
          vim.ui.select(result, {
            prompt = 'Choose a file to run',
          }, function(choice)
            if choice == nil then
              vim.print("Resuming (abort) with " .. vim.inspect(choice))
              callback(nil)
            else
              callback(vim.loop.fs_realpath(choice))
            end
          end)
        end
      end
    })
  end)
end

function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  if type(rhs) ~= 'string' then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.keymap.set(mode, lhs, '<cmd>' .. rhs .. '<cr>', opts)
  end
end

function M.nmap(lhs, rhs, opts)
  M.map({ 'n' }, lhs, rhs, opts)
end

function M.windowctl(lhs, rhs, opts)
  M.map({ 'n', 't' }, lhs, 'wincmd ' .. rhs, opts)
end

function M.get_visual_selection()
  local mode = vim.fn.mode()
  local sl, sc, el, ec, bn
  if mode == 'V' then
    bn, sl, _ = unpack(vim.fn.getpos("v")) ---@diagnostic disable-line
    _, el, _ = unpack(vim.fn.getpos(".")) ---@diagnostic disable-line
    ec = vim.v.maxcol
    sc = 1
    if el < sl then
      el, sl = sl, el
    end
  elseif mode == 'v' then
    bn, sl, sc = unpack(vim.fn.getpos("v")) ---@diagnostic disable-line
    _, el, ec = unpack(vim.fn.getpos(".")) ---@diagnostic disable-line
    if el < sl or (el == sl and ec < sc) then
      el, ec, sl, sc = sl, sc, el, ec
    end
  else
    bn, sl, sc = unpack(vim.fn.getpos("'<")) ---@diagnostic disable-line
    _, el, ec = unpack(vim.fn.getpos("'>")) ---@diagnostic disable-line
  end

  local lines = vim.api.nvim_buf_get_lines(bn, sl - 1, el, false)
  if #lines == 0 then
    error('No selection returned in get_visual_selection()')
  end
  if sl == el then
    lines[1] = string.sub(lines[1], sc, ec)
  else
    lines[1] = string.sub(lines[1], sc)
    lines[#lines] = string.sub(lines[#lines], 1, ec)
  end
  return table.concat(lines, '\n')
end

function M.has_word_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.show_in_float(what, opts)
  opts = opts or {}
  local focus_win = true
  if opts.focus ~= nil then
    focus_win = opts.focus
  end
  local height = 5
  local type_what = type(what)
  if type_what == 'table' then
    height = math.min(math.max(#what, height), vim.o.lines - 4)
  elseif type_what == 'function' then
    what = what()
    height = math.min(#what, height)
  elseif type_what == 'string' then
    what = { what }
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buffer, 'buftype', 'nofile')
  vim.api.nvim_buf_set_lines(buffer, 0, -1, true, what)
  vim.api.nvim_buf_set_option(buffer, 'modifiable', false)

  local width = math.floor(vim.o.columns * 2 / 3)
  local window = { id = nil, bufnr = buffer }
  local line = math.floor(((vim.o.lines - height) / 2) - 1)
  local col = math.floor((vim.o.columns - width) / 2) - 1

  opts = vim.tbl_extend('keep', opts, {
    relative = 'editor', -- editor, win, cursor, mouse
    width = width,       -- h/w of the window itself, excluding border
    height = height,
    title_pos = 'center', -- left, center, right
    border = 'rounded',   -- none, single, double, rounded, solid, shadow / { 'c', ... }, { {'c', 'HighlightGroup' }, ... }
    row = line,           -- position of the window
    col = col,
  })

  window.id = vim.api.nvim_open_win(buffer, focus_win, opts)

  function window:close_popup()
    vim.api.nvim_win_close(self.id, true)
  end

  vim.api.nvim_create_autocmd({ 'BufLeave' }, {
    once = true,
    buffer = buffer,
    callback = function() window:close_popup() end,
  })

  vim.keymap.set('n', 'q', function() window:close_popup() end, { buffer = window.bufnr })
  vim.keymap.set('n', '<esc>', function() window:close_popup() end, { buffer = window.bufnr })
  return window
end

return M
