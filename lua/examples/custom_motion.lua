local function set_print_range()
  local oldfunc = vim.go.operatorfunc
  function _G.PrintRange(mode)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '['))
    local stop_row, stop_col = unpack(vim.api.nvim_buf_get_mark(0, ']'))
    if mode == 'line' then
      start_col = 0
      stop_col = -1
    else
      stop_col = stop_col + 1
    end
    local content = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, stop_row - 1, stop_col, {})
    --[[
  Do the work here
  --]]
    vim.print(content)
    vim.go.operatorfunc = oldfunc
    _G.PrintRange = nil
  end

  vim.go.operatorfunc = [[v:lua.PrintRange]]
  vim.api.nvim_feedkeys('g@', 'n', false)
end

vim.keymap.set('n', '<leader>P', set_print_range, { silent = true })

local function find_bool()
  local line, col = unpack(vim.fn.searchpos('BOOL', 'c'))
  if line == 0 and col == 0 then
    return
  end
  vim.api.nvim_win_set_cursor(0, { line, col - 2 })
  vim.cmd.normal [[ v ]]
  vim.api.nvim_win_set_cursor(0, { line, col + 2 })
end
vim.keymap.set('o', 'A', find_bool)
