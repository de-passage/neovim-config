local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local telescope = require('telescope')

local function find_config(opts)
  opts = opts or {}
  local config_path = vim.fn.stdpath('config') .. '/lua'

  pickers.new(opts, {
    prompt_title = 'Find Config',
    finder = finders.new_oneshot_job(
      { 'fd', '.*\\.lua$', '--type', 'f', '--hidden', '--no-ignore', '--full-path', '--absolute-path', config_path }, {
        entry_maker = function(line)
          local relpath = line:gsub(config_path .. '/', '')
          return {
            value = line,
            display = relpath,
            ordinal = relpath,
          }
        end
      }),
    previewer = conf.file_previewer(conf),
    sorter = conf.file_sorter(conf),
  }):find()
end

return telescope.register_extension {
  exports = {
    find_config = find_config,
  },
}
