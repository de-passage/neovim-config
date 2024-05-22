local M = {}
function M.find_executable()
  return coroutine.create(function(to_resume)
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
          coroutine.resume(to_resume, require 'dap'.ABORT)
        else
          vim.ui.select(result, {
            prompt = 'Choose a file to run',
          }, function(choice)
            if choice == nil then
              vim.print("Resuming (abort) with " .. vim.inspect(choice))
              coroutine.resume(to_resume, require 'dap'.ABORT)
            else
              vim.print("Resuming with " .. vim.inspect(choice))
              coroutine.resume(to_resume, vim.loop.fs_realpath(choice))
            end
          end)
        end
      end
    })
  end)
end

return M
