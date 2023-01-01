local m = require('utils.map')

vim.o.number = true
vim.o.incsearch = true
vim.o.expandtab = true
vim.o.hlsearch = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.mouse = 'a'
vim.o.completeopt = "menu,menuone,noselect"
vim.g.mapleader = ' '
vim.o.foldtext = [[getline(v:foldstart).'...'.trim(getline(v:foldend))]]
vim.o.fillchars = [[fold: ]]
vim.o.foldnestmax = 3
vim.o.foldminlines = 1
vim.o.foldenable = false
vim.o.undofile = true

local basic_group = vim.api.nvim_create_augroup('BasicAutocommands', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = basic_group,
  pattern = { '*' },
  callback = function()
    local restore_view_pls = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(restore_view_pls)
  end
})
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = basic_group,
  pattern = { '/tmp/*' },
  command = [[setlocal noundofile]]
})

m.map({ 'i', 'n' }, '<C-s>', 'w')
m.windowctl('<M-n>', 'keepjumps bn!')
m.windowctl('<M-p>', 'keepjumps bN!')
m.windowctl('<M-h>', 'keepjumps wincmd h')
m.windowctl('<M-j>', 'keepjumps wincmd j')
m.windowctl('<M-k>', 'keepjumps wincmd k')
m.windowctl('<M-l>', 'keepjumps wincmd l')

require 'plugins'
vim.cmd('colorscheme duskfox')
m.nmap('<leader>u', 'UndotreeToggle')