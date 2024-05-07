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

return M
