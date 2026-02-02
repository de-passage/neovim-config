return {
  setup = function() 
    local map = require 'utils.map'.map
    local nmap = require 'utils.map'.nmap

    local dap = require 'dap'
    local cpp = require 'config.dap.cpp'
    local cmake = require 'config.dap.cmake'

    dap.adapters = vim.tbl_extend('error', dap.adapters, cpp.adapters)
    dap.adapters = vim.tbl_extend('error', dap.adapters, cmake.adapters)

    dap.configurations.c = cpp.configurations
    dap.configurations.cpp = cpp.configurations
    dap.configurations.cmake = cmake.configurations

    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = '@markup.strong', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = '@markup.strong', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '⦿', texthl = '@markup.strong', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = '@markup.strong', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '→', texthl = '@markup.link', linehl = 'CursorLine', numhl = 'CursorLineNr' })

    -- Missing from
    vim.api.nvim_create_user_command('DapDisconnect', function()
      dap.disconnect()
      dap.close()
    end, { nargs = 0, desc = "Disconnects from the debugee without terminating it ('attach' only)" })

    nmap('<F6>', function() dap.continue() end)
    nmap('<F10>', function() dap.step_over() end)
    nmap('<F11>', function() dap.step_into() end)
    nmap('<F12>', function() dap.step_out() end)
    nmap('<F24>', function() dap.terminate() end)
    nmap('<Leader>ll', function() dap.toggle_breakpoint() end)
    nmap('<Leader>lL', function() dap.set_breakpoint() end)
    nmap('<Leader>lbp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    nmap('<Leader>lr', function() dap.repl.open() end)
    nmap('<Leader>la', function() dap.run_last() end)

    local dapui = require 'dapui'
    ---@diagnostic disable
    dapui.setup {
      icons = {
        current_frame = '→'
      }
    }
    ---@diagnostic enable

    local function init_dapui()
      nmap('<m-u>', function() dap.up() end)
      nmap('<m-d>', function() dap.down() end)
      map({ 'n', 'v' }, '<c-k>', function() dapui.eval() end)
      dapui.open()
    end
    local function terminate_dapui()
      pcall(vim.keymap.del, 'n', '<m-u>')
      pcall(vim.keymap.del, 'n', '<m-d>')
      pcall(vim.keymap.del, {'n', 'v'}, '<c-k>')
      pcall(dapui.close)
    end

    dap.listeners.after.launch.dapui_config = init_dapui
    dap.listeners.after.attach.dapui_config = init_dapui
    dap.listeners.after.disconnect.dapui_config = terminate_dapui
    dap.listeners.before.event_exited.dapui_config = terminate_dapui
    dap.listeners.before.event_terminated.dapui_config = terminate_dapui
    vim.keymap.set('n', '<Leader>lU', function()
      dapui.toggle()
    end)

    require 'nvim-dap-virtual-text'.setup {}

    local workspace_directory = require('workspace').data_directory
    local filename = workspace_directory .. '/dap.lua'
    if vim.loop.fs_stat(filename) then
      local ok, result = pcall(dofile, filename)
      if ok then
        vim.notify("Local DAP configuration loaded", vim.log.levels.INFO)
      else
        error("Failed to load " .. filename .. result)
      end
    end

    pcall(require, 'config.local.dap')


  end
} 