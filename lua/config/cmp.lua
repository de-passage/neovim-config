local cmp = require 'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-c>'] = cmp.mapping.abort(),
    ['<C-Y>'] = cmp.mapping(function(fallback)
      local copilot_keys = vim.fn["copilot#Accept"]()
      if copilot_keys ~= "" then
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
      else
        fallback()
      end
    end, {'i'}),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if vim.fn["vsnip#jumpable"](1) == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), '', true)
      else
        fallback()
      end
    end),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if vim.fn["vsnip#jumpable"](-1) == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), '', true)
      else
        fallback()
      end
    end),
    ['<Esc>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.mapping.abort()
        fallback()
      else
        fallback()
      end
    end),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<space>'] = cmp.mapping(function(fallback)
      cmp.mapping.confirm({ select = true })
      fallback()
    end),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        --      elseif luasnip.expand_or_jumpable() then
        --        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        --      elseif luasnip.jumpable(-1) then
        --        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'path' },
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' }
  })
})


-- Set configuration for specific filetype.
--cmp.setup.filetype('gitcommit', {
--  sources = cmp.config.sources({
--    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--  }, {
--    { name = 'buffer' },
--  })
--})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }, { name = 'cmdline'}
--   }
--   )
-- })
