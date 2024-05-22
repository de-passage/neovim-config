local dap = require 'dap'
local find_executable = require 'config.dap.utility'.find_executable
local configurations =
{
  {
    name = 'CppDbg',
    type = 'cppdbg',
    request = 'launch',
    program = find_executable,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing',
        ignoreFailures = true
      },
      {
        text = 'set detach-on-fork off',
        description = 'Allow debugging of child processes',
      },
      {
        text = 'set non-stop on',
        description = 'Do not stop when process exits',
      },
      {
        text = 'set follow-fork-mode child',
        description = 'Child is debugged',
      },
      {
        text = 'set pagination on',
        description = 'Print command output 1 screen at a time',
      }
    },
    miDebuggerPath = "/gdb",
    MIMode = 'gdb'
  },
  {
    logging = {
      engineLogging = true,
      trace = 'true',
    },
    name = "GDB (Launch)",
    type = "gdb",
    request = "launch",
    program = find_executable,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false
  },
  {
    type = 'gdb',
    request = 'attach',
    name = "GDB (Attach)",
    pid =
        function()
          -- This is exceedingly confusing because pick_process is very poorly behaved.
          -- It doesn't respect nvim-dap's own convention about coroutines and resumes whatever
          -- coroutine was in progress when the function was called. Apparently something
          -- is when the function producing pid is called, causing chaos at the call site
          -- of pick_process
          --
          -- In short, we need to create a paused coroutine that will be resumed by the caller
          -- with the coroutine to continue when we have a result
          return coroutine.create(function(coro_to_resume)
            -- We get a stopped coroutine that will launch an asynchronous process
            local co = require 'dap.utils'.pick_process()

            if co == nil then   -- if it failed, abort the debug session
              coroutine.resume(coro_to_resume, dap.ABORT)
              return
            end

            -- we restart the coroutine, which actually schedules the current coroutine to be resumed
            -- at a later point (vim.schedule)
            -- local ok, _ =
            coroutine.resume(co)

            -- I don't think this can happen, it would mean that the coroutine was already started,
            -- and we know it isn't (by looking into the implementation)
            --[[ if not ok then
                coroutine.resume(coro_to_resume, dap.ABORT)
                return
              end ]]

            -- At this point, we're relying on the fact that pick_process() has retrieved our
            -- coroutine id and will resume it in a defered vim.schedule() call. We suspend
            -- waiting for that to happen
            local picked = coroutine.yield()
            if picked == nil or tonumber(picked) == nil then
              coroutine.resume(coro_to_resume, dap.ABORT)
            else
              coroutine.resume(coro_to_resume, picked)
            end
          end)
        end
  },
  {
    name = 'GDB (Empty)',
    type = 'gdb',
    request = 'launch'
  },
}
local adapters = {
  gdb = {
    type = 'executable',
    command = 'gdb',
    args = { '-i', 'dap' },
  },
  cppdbg = {
    id = 'cppdbg',
    command = 'OpenDebugAD7',
    type = 'executable'
  },
  lldb = {
    type = 'executable',
    command = 'lldb-vscode',
    name = 'lldb'
  },
}

return {
  adapters = adapters,
  configurations = configurations
}
