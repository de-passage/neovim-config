return {
  -- Colorscheme
  {
    "EdenEast/nightfox.nvim",
    main = 'config.nightfox',
    opts = {}
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
    opts = {}
  },

  {
    'windwp/nvim-autopairs',
    opts = {}
  },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    opts = {}
  },

  -- Syntax analysis
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    opts = {},
    main = "config.treesitter"
  },

  -- Pretty bars
  { 'nvim-tree/nvim-web-devicons' },

  {
    'nvim-lualine/lualine.nvim',
    opts = {}
  },

  -- LSP configuration
  {
    'nvimtools/none-ls.nvim',
    opts = {},
    main = 'config.null_ls' ,

  },
  {
    'neovim/nvim-lspconfig',
    opts = {},
    main = 'config.lspconfig'
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
      require("outline").setup { }
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
    opts = {},
    main = 'config.cmp'
  },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-vsnip' },

  -- Snippets
  { 'hrsh7th/vim-vsnip' },

  -- Telescope (extension config is done in the config.telescope module)
  {
    'nvim-telescope/telescope.nvim',
    opts = {},
    main = 'config.telescope',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
  },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  {
    "de-passage/telescope-makefile",
    dependencies = {
      { "akinsho/toggleterm.nvim" },
      { 'nvim-telescope/telescope.nvim' }
    },
  },
  { "nvim-telescope/telescope-file-browser.nvim" },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = '*',
    opts = {},
    main = 'config.toggleterm'
  },

  {
    'github/copilot.vim',
    opts = {},
    main = 'config.copilot'
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {}
  },

  { 'purescript-contrib/purescript-vim' },

  -- Debugger support
  {
    'mfussenegger/nvim-dap',
    opts = {},
    main = 'config.dap'
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = {
      { "mfussenegger/nvim-dap" },
    },
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
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
    opts = {},
    dependencies = {
      { "mfussenegger/nvim-dap" },
    },
  },

  {
    'RaafatTurki/hex.nvim',
    opts = {}
  },
  { "Shirk/vim-gas" },
  { "HiPhish/info.vim" },
}
