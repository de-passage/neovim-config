local dap = require('dap')
local map = require('utils.map')

map.map('n', '<F5>', function()
  dap.toggle_breakpoint()
end)

map.map('n', '<F10>', function()
  dap.step_over()
end)

map.map('n', '<F8>', function()
  dap.continue()
end)

-- create an autocmd to toggle a breakpoint
dap.adapters.gdb = {
  name = 'gdb',
  type = 'executable',
  command = 'gdb',
}
dap.adapters.lldb = {
  name = 'lldb',
  type = 'executable',
  command = 'lldb-vscode-10',
}

local gdb = {
  name = 'Launch gdb',
  type = 'gdb',
  request = 'launch',
  program = function()
    return vim.fn.input {
      prompt = 'Path to executable: ',
      default = vim.fn.getcwd() .. '/' ,
      completion = 'file'
    }
  end,
  cwd = '${workspaceFolder}',
  stopOnEntry = true,
  args = {},
  runInTerminal = false,
}

local lldb = {
  name = 'Launch lldb',
  type = 'lldb',
  request = 'launch',
  program = function()
    return vim.fn.input {
      prompt = 'Path to executable: ',
      default = vim.fn.getcwd() .. '/build' ,
      completion = 'file'
    }
  end,
  cwd = '${workspaceFolder}',
  stopOnEntry = true,
  args = {},
  runInTerminal = false,
}

dap.configurations.cpp = { lldb }
