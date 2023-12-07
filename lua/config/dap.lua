local dap = require('dap')
local map = require('utils.map')

map.map('n', '<F5>', function()
  dap.toggle_breakpoint()
end)

-- create an autocmd to toggle a breakpoint
