-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('neodev').setup()
local lspconfig = require 'lspconfig'
local lsp_keymaps = require 'utils.keymap'

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>Q', vim.diagnostic.setloclist, opts)

vim.api.nvim_create_user_command('LspDiagnostics',
  function (_)
    vim.diagnostic.setqflist({ open = true })
  end, {})

local extra_settings = {
  jdtls = {
    java = {
      home = "/usr/lib/jvm/java-1.17.0-openjdk-amd64/",
    }
  },
  sumneko_lua = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  purescriptls = {
    purescript = {
      addSpagoSources = true,
    },
  }
}


capabilities.offsetEncoding = { "utf-16" }

for _, lspserver in ipairs({ 'clangd', 'bashls', 'jsonls', 'jedi_language_server', 'jdtls', 'lua_ls', 'gopls', 'glslls', 'purescriptls', 'rust_analyzer', 'hls', 'asm_lsp' }) do
  local settings = {};
  if extra_settings[lspserver] ~= nil then
    settings = extra_settings[lspserver]
  end

  lspconfig[lspserver].setup {
    capabilities = capabilities,
    on_attach = lsp_keymaps.on_attach,
    settings = settings
  }
end
