local m = require('utils.map')

vim.o.errorformat = '%-Gmake[%*\\d]: *** [%f:%l:%m,' .. '%-Gmake: *** [%f:%l:%m,' .. vim.o.errorformat
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

local go_group = vim.api.nvim_create_augroup('GoAutocommands', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWrite' }, {
  group = go_group,
  pattern = { '*.go' },
  command = [[silent! lua vim.lsp.buf.format()]]
})

local gdscriptgroup = vim.api.nvim_create_augroup('GDScriptAutocommands', { clear = true })
-- Use tabs for GDScript files
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = gdscriptgroup,
  pattern = { '*.gd' },
  command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab list]]
})

-- Window navigation
m.map({ 'i', 'n' }, '<C-s>', 'w')
m.windowctl('<M-n>', 'keepjumps bn!')
m.windowctl('<M-p>', 'keepjumps bN!')
m.windowctl('<M-h>', 'keepjumps wincmd h')
m.windowctl('<M-j>', 'keepjumps wincmd j')
m.windowctl('<M-k>', 'keepjumps wincmd k')
m.windowctl('<M-l>', 'keepjumps wincmd l')
m.nmap('<F5>', 'make | cwin 5')

-- Config edition
vim.api.nvim_create_user_command('OpenConfig', [[e $MYVIMRC]], {})

require 'plugins'

m.nmap('<leader>u', 'UndotreeToggle')
m.nmap('<leader>d', vim.diagnostic.open_float)

-- System clipboard support
vim.o.clipboard = "unnamedplus"
if vim.fn.has('wsl') == 1 then
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('Yank', { clear = true }),
    callback = function()
      vim.fn.system('/mnt/c/Windows/System32/clip.exe', vim.fn.getreg('"'))
    end,
  })
end

pcall(require, 'config.local')
vim.cmd.colorscheme 'nightfox'
