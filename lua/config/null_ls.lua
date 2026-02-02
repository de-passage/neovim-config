return {
  setup = function()
    local null_ls = require 'null-ls'

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.code_actions.gitsigns
      },
      on_attach = require('utils.keymap').on_attach,
      capabilities = {
        offsetEncoding = { 'utf-16' }
      }
    })
  end
}