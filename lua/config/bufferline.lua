return {
  setup = function()
    require('bufferline').setup()
    local m = require 'utils.map'
    m.nmap('<M-n>', 'BufferNext')
    m.nmap('<M-p>', 'BufferPrevious')
  end
}
