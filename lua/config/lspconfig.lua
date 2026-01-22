-- Set up lspconfig.
---WORKAROUND
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
  end
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('neodev').setup()
local lsp_keymaps = require 'utils.keymap'

local border_style = "rounded"
require('lspconfig.ui.windows').default_options.border = 'single'

vim.diagnostic.config({
  float = {
    border = border_style
  }
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, opts)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, opts)
vim.keymap.set('n', '<space>Q', vim.diagnostic.setloclist, opts)

vim.api.nvim_create_user_command('LspDiagnostics',
  function(_)
    vim.diagnostic.setqflist({ open = true })
  end, {})

local extra_settings = {
  jdtls = {
    java = {
      home = "/usr/lib/jvm/java-1.17.0-openjdk-amd64/",
    }
  },
  ['lua_ls'] = {
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

local extra_on_attach = {
  clangd = function(client, bufnr)
    lsp_keymaps.on_attach(client, bufnr)
    require('utils.map').nmap('<m-o>', 'ClangdSwitchSourceHeader', { silent = true, buffer = bufnr })
  end
}


capabilities.offsetEncoding = { "utf-16" }

local default_servers = { "lua_ls" }
local ok, local_config = pcall(require, 'config.local.lspconfig')
local lsp_augroup = vim.api.nvim_create_augroup('LspAutocmds', {})

if ok then
  default_servers = vim.tbl_extend('force', default_servers, local_config.servers or {})
  extra_settings = vim.tbl_extend('force', extra_settings, local_config.extra_settings or {})
end

for _, lspserver in ipairs(default_servers) do
  local settings = {};
  if extra_settings[lspserver] ~= nil then
    settings = extra_settings[lspserver]
  end

  vim.lsp.config(lspserver, {
    capabilities = capabilities,
    -- on_attach = extra_on_attach[lspserver] or lsp_keymaps.on_attach,
    settings = settings
  })

  vim.lsp.enable(lspserver)

  local run_on_attach = extra_on_attach[lspserver] or lsp_keymaps.on_attach

  vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_augroup,
    callback = function(ev)
      local bufnr = ev.buf
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      run_on_attach(client, bufnr)
    end
  })
end
