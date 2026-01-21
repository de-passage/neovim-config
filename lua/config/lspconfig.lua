-- Set up lspconfig.
---WORKAROUND
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
  end
})

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "cpp" },

  ignore_install = {},
  modules = {},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>NN", -- set to `false` to disable one of the mappings
      node_incremental = "<leader>Nn",
      scope_incremental = "<leader>Nc",
      node_decremental = "<leader>Nm",
    },
  }
}
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('neodev').setup()
local lsp_keymaps = require 'utils.keymap'

local border_style = "rounded"
require('lspconfig.ui.windows').default_options.border = 'single'
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border_style
  })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border_style
  })

vim.diagnostic.config({
  float = {
    border = border_style
  }
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
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
    require('utils.map').nmap('<m-o>','ClangdSwitchSourceHeader', { silent = true, buffer = bufnr })
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
