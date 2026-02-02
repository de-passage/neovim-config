local function configfile(modulename)
  return 'require("config.' .. modulename .. '")'
end

local function setup(modulename)
  return 'require("' .. modulename .. '").setup()'
end

return {
  -- Colorscheme
  {
    "EdenEast/nightfox.nvim",
    config = configfile('nightfox')
  },
  -- Essentials
  { 'tpope/vim-surround' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-unimpaired' },
  { 'mbbill/undotree' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'numToStr/Comment.nvim',
    config = setup('Comment')
  },

  {
    'windwp/nvim-autopairs',
    config = setup('nvim-autopairs')
  },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    config = setup('gitsigns')
  },

  -- Syntax analysis
  {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = configfile('treesitter')
  },

  -- Pretty bars
  {
    'nvim-lualine/lualine.nvim',
    wants = 'nvim-web-devicons',
    requires = {
      'nvim-tree/nvim-web-devicons', opt = true
    },
    config = setup('lualine')
  },

  -- LSP configuration
  {
    'nvimtools/none-ls.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = configfile("null_ls")
  },
  {
    'neovim/nvim-lspconfig',
    config = configfile('lspconfig')
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      local illum = require 'illuminate'
      vim.keymap.set('n', '<C-n>', illum.goto_next_reference)
      vim.keymap.set('n', '<C-p>', illum.goto_prev_reference)
    end,
  },
  {
    'folke/neodev.nvim'
  },

  {
    "hedyhli/outline.nvim",
    config = function()
      vim.keymap.set("n", "<leader>v", "<cmd>Outline<cr>")
      require("outline").setup {
      }
    end
  },

  -- Completion
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-vsnip' },
  {
    'hrsh7th/nvim-cmp',
    config = configfile('cmp')
  },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-vsnip' },

  -- Snippets
  { 'hrsh7th/vim-vsnip' },

  -- Telescope (extension config is done in the config.telescope module)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = configfile('telescope')
  },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  {
    "de-passage/telescope-makefile",
    requires = {
      { "akinsho/toggleterm.nvim" },
      { 'nvim-telescope/telescope.nvim' }
    },
  },
  { "nvim-telescope/telescope-file-browser.nvim" },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = configfile('toggleterm')
  },

  {
    'github/copilot.vim',
    config = configfile('copilot')
  },

  {
    "williamboman/mason.nvim",
    run = ":MasonUpdate",
    config = configfile('mason')
  },

  { 'purescript-contrib/purescript-vim' },

  -- Debugger support
  {
    'mfussenegger/nvim-dap',
    config = configfile('dap')
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    requires = {
      { "mfussenegger/nvim-dap" },
    },
  },

  {
    'rcarriga/nvim-dap-ui',
    requires = {
      {
        "mfussenegger/nvim-dap",
      },
      {
        'nvim-neotest/nvim-nio',
      }
    },
  },

  {
    "leoluz/nvim-dap-go",
    config = setup('dap-go'),
    requires = {
      { "mfussenegger/nvim-dap" },
    },
  },

  {
    'RaafatTurki/hex.nvim',
    config = setup('hex')
  },
  { "Shirk/vim-gas" },
  { "HiPhish/info.vim" },

}
