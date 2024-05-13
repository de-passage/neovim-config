local M = {}
function M.redir(func)
  local run = func
  if type(func) == 'string' then
    run = function() vim.cmd ('silent exec ' .. "'" .. func .. "'") end
  else
    error('redir() must be called with a string containing a vim command')
  end

  vim.cmd [[ redir => ___dpsg_redir_output ]]
  local ok, err = pcall(run)
  vim.cmd [[ redir END ]]
  if not ok then
    error(err)
  else
    local results = vim.api.nvim_get_var('___dpsg_redir_output') ---@type string
    local eol_char = 1
    local start = 1
    local return_value = {}

    while start < #results do
      eol_char, stop = results:find('\n', start)
      if eol_char == nil then
        return_value[#return_value+1] = results:sub(start, #results)
        break
      end
      return_value[#return_value+1] = results:sub(start, eol_char - 1)
      start = stop + 1
    end
    return return_value
  end
end
return M
