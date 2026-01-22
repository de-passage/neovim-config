local lsp_document_highlight_augroup = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = true })
local function lsp_highlight_document(client)
  if client.server_capabilities.document_highlight then
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = lsp_document_highlight_augroup,
      callback = vim.lsp.buf.document_hightlight,
      buffer = 0
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = lsp_document_highlight_augroup,
      callback = vim.lsp.buf.clear_references,
      buffer = 0
    })
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local border_style = { border = "rounded" }

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover(border_style) end, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help(border_style) end, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>gy', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>F', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set('v', '<space>F', function() vim.lsp.buf.format { async = true } end, bufopts)

  lsp_highlight_document(client)
end

return {
  on_attach = on_attach
}
