vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

local m = require('utils.map')
m.iplug_map('<C-j>', 'copilot-next')
m.iplug_map('<C-k>', 'copilot-previous')
m.imap('<C-y>', [[ copilot#Accept("\<CR>") ]])
