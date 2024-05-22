local telescope = require('telescope')

local themes = require('telescope.themes')
telescope.setup {
  extensions = {
    ['ui-select'] = {
      themes.get_cursor {
      }
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    }
  }
}

local b = require('telescope.builtin')

vim.keymap.set('n', '<leader>Gr', function() b.lsp_references {} end)
vim.keymap.set('n', '<leader>GI', function() b.lsp_incoming_calls {} end)
vim.keymap.set('n', '<leader>GO', function() b.lsp_outgoing_calls {} end)
vim.keymap.set('n', '<leader>s', function() b.lsp_document_symbols {} end)
vim.keymap.set('n', '<leader>D', function() b.diagnostics {} end)
vim.keymap.set('n', '<leader>Gi', function() b.lsp_implementations {} end)
vim.keymap.set('n', '<leader>Gd', function() b.lsp_definitions {} end)
vim.keymap.set('n', '<leader>Gy', function() b.lsp_type_definition {} end)

vim.keymap.set('n', '<leader>f', function() b.find_files {} end)
vim.keymap.set('n', '<leader>b', function() b.buffers {} end)
vim.keymap.set('n', '<leader>tf', function() b.grep_string {} end)
vim.keymap.set('n', '<leader>tg', function() b.live_grep {} end)
vim.keymap.set('n', '<leader>T', function() b.builtin {} end)
vim.keymap.set('n', '<leader>th', b.help_tags)
vim.keymap.set('n', '<leader>tr', b.resume)

require 'telescope-makefile'.setup {
  -- The path where to search the makefile in the priority order
  makefile_priority = { '.', 'build/' },
  default_target = '[DEFAULT]', -- nil or string : Name of the default target | nil will disable the default_target
  make_bin = "make", -- Custom makefile binary path, uses system make by def
}

telescope.load_extension('make')
telescope.load_extension('ui-select')
telescope.load_extension('fzf')
telescope.load_extension('file_browser')
