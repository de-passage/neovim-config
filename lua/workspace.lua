local M = {
  data_directory = vim.fn.finddir('.vim/', ';'), ---@type string | nil
  directory = '' ---@type string
}

if not M.data_directory or M.data_directory == "" then
  M.data_directory = vim.loop.fs_realpath(vim.fn.getcwd() or '.') .. '/.vim'
else
  M.data_directory = vim.loop.fs_realpath(M.data_directory) ---@diagnostic disable-line
  vim.opt.runtimepath:append(M.data_directory)
end

M.directory = vim.fn.fnamemodify(M.data_directory, ':h:r')

if vim.loop.fs_stat(M.data_directory .. '/init.lua') then
  dofile(M.data_directory .. '/init.lua')
end

return M
