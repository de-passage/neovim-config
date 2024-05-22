---@param str string
---@param match string
---@return string[]
function string.split(str, match)
  local eol_char = 1
  local start, stop = 1, 1
  local return_value = {}

  while start < #str do
    eol_char, stop = str:find(match, start)
    if eol_char == nil then
      return_value[#return_value + 1] = str:sub(start, #str)
      break
    end
    return_value[#return_value + 1] = str:sub(start, eol_char - 1)
    start = stop + 1
  end
  return return_value
end
