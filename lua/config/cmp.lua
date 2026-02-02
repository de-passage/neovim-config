return {
  setup = function ()
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
        ['<C-u>'] = cmp.mapping.scroll_docs(-2),
        ['<C-d>'] = cmp.mapping.scroll_docs(2),
        ['<C-e>'] = cmp.mapping.scroll_docs(1),
        ['<C-c>'] = cmp.mapping.abort(),
        ['<C-t>'] = cmp.mapping(function(fallback)
          local copilot_keys = vim.fn["copilot#Accept"]()
          if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
          else
            fallback()
          end
        end),
        ['<C-y>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end, { 'i' }),
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
        end)
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' },
      }, {
        { name = 'buffer' },
        { name = 'nvim_lsp_signature_help' }
      }),
      experimental = {
        ghost_text = false,
      },
      window = {
        completion = {
          border = 'single',
          scrollbar = true,
        },
        documentation = { border = 'rounded' }
      },
    })

  end
}