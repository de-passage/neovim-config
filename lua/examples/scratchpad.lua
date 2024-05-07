local u = require('utility')
local session_scratch_pads = {} --- @type { [number]:string}

---@param temp_path string
---@param ft string?
local function open_scratch_buffer(temp_path, ft)
  vim.cmd.split(temp_path)

  local current = vim.api.nvim_get_current_buf()
  vim.bo.bufhidden = 'wipe'
  if ft ~= nil then
    vim.opt_local.ft = ft
  end
  vim.opt_local.swapfile = false
  vim.opt_local.undofile = false
  vim.api.nvim_create_autocmd({'BufModifiedSet'}, {
    buffer = current,
    callback = function(_)
      vim.cmd.w()
    end,
  })
  if vim.bo.ft == 'lua' then
    vim.keymap.set('n', '<F5>', function()
      vim.cmd.source(temp_path)
    end, {
      silent = true,
      buffer = current,
    })
    vim.keymap.set('v', '<F5>', function()
      local f, err = load(u.get_visual_selection())
      if f == nil then
        error(err)
      else
        f()
      end
    end, {
      silent = true,
      buffer = current
    })
  end
end

local M = {}

function M.setup(_)

  vim.api.nvim_create_user_command('Scratch', function(cmd)
    local filetype = cmd.args ~= "" and cmd.args or 'lua'
    local temp_path = vim.fn.tempname() .. '.' .. filetype
    table.insert(session_scratch_pads, temp_path)
    open_scratch_buffer(temp_path, filetype)
  end, {
    nargs = '?',
    complete = 'filetype'
  })

  vim.api.nvim_create_user_command('ScratchEdit', function(cmd)
    open_scratch_buffer(cmd.args)
  end, {
    nargs = 1,
    complete = function(arg)
      if (arg == '') then
        return session_scratch_pads
      end
      local result_table = {}
      local regex = '^' .. arg
      for _, el in ipairs(session_scratch_pads) do
        if el:match(regex) then
          table.insert(result_table, el)
        end
      end
    end
  })
end

return M
