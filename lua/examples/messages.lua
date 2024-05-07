local show = require 'utility'.show_in_float

vim.cmd [[
  redir => messages_output___
  silent execute('messages')
  redir END
]]

local messages_one_line = vim.api.nvim_get_var("messages_output___")
local messages = {}
local start, stop = 1, 1
while true do
  stop  = messages_one_line:find('\n', start)
  if stop == nil then break end
  messages[#messages+1] = messages_one_line:sub(start, stop-1)
  start = stop+1
end
local win = show(messages, { title = "Messages" })
local last_line = #messages
local last_col = 0
if last_line > 0 then
  last_col = math.max(0, #messages[last_line] - 1)
end
vim.api.nvim_win_set_cursor(win.id, {last_line, last_col})
