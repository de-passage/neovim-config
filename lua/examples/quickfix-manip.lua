local function delete_line_from_qf()
  assert(vim.opt.ft:get() == 'qf', "Should only be called on qflist")
  local pos = vim.fn.getpos('.') or {}
  local linenr = pos[2]

  local new_list = {}
  for idx, lcontent in ipairs(vim.fn.getqflist() or {}) do
    if idx ~= linenr then
      new_list[#new_list+1] = lcontent
    end
  end

  vim.fn.setqflist(new_list, 'r')
  vim.fn.setpos('.', pos)
end

---@param winnr number
local function delete_line_from_loc(winnr)
  assert(vim.opt.ft:get() == 'qf', "Should only be called on qflist")
  local pos = vim.fn.getpos('.') or {}
  local linenr = pos[2]

  local new_list = {}
  for idx, lcontent in ipairs(vim.fn.getloclist(winnr) or {}) do
    if idx ~= linenr then
      new_list[#new_list+1] = lcontent
    end
  end

  vim.fn.setloclist(winnr, new_list, 'r')
  vim.fn.setpos('.', pos)
end

-- [[
local group = vim.api.nvim_create_augroup('DpsgQfAugroup', { clear = true })
vim.api.nvim_create_autocmd('FileType',
  {
    group = group,
    pattern = 'qf',
    desc = 'Create keymaps to manipulate the quickfix list',
    callback = function(opts)
      vim.opt.buflisted = false
      local info = unpack(vim.fn.getwininfo(vim.api.nvim_get_current_win()) or {}, 1, 1)

      local cb
      if info ~= nil and info.loclist == 1 then
        cb = function() delete_line_from_loc(info.winnr) end
      else
        cb = delete_line_from_qf
      end

      vim.keymap.set('n', 'dd', cb, {
        buffer = opts.buf,
        silent = true
      })
    end
  })
--]]
