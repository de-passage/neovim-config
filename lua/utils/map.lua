local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  if type(rhs) ~= 'string' then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.keymap.set(mode, lhs, '<cmd>'..rhs..'<cr>', opts)
  end
end

local nmap = function(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
end

local windowctl = function(lhs, rhs, opts)
  map({ 't', 'n' }, lhs, rhs, opts)
end

return {
  map = map,
  nmap = nmap,
  windowctl = windowctl
}
