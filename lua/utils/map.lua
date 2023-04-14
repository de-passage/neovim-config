local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  if type(rhs) ~= 'string' then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.keymap.set(mode, lhs, '<cmd>'..rhs..'<cr>', opts)
  end
end

local imap = function(lhs, rhs, opts)
  map('i', lhs, rhs, opts)
end

local nmap = function(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
end

local windowctl = function(lhs, rhs, opts)
  map({ 't', 'n' }, lhs, rhs, opts)
end

local plug_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = false
  opts.silent = true
  opts.expr = false
  vim.keymap.set(mode, lhs, '<Plug>(' .. rhs .. ')', opts)
end

local iplug_map = function(lhs, rhs, opts)
  plug_map('i', lhs, rhs, opts)
end

return {
  map = map,
  imap = imap,
  nmap = nmap,
  windowctl = windowctl,
  plug_map = plug_map,
  iplug_map = iplug_map,
}
