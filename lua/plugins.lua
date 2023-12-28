local function configfile(modulename)
  return 'require("config.' .. modulename .. '")'
end

local function setup(modulename)
  return 'require("' .. modulename .. '").setup()'
end

return require('packer').startup(function(use)
  -- Packer needs to know itself...
  use { "wbthomason/packer.nvim" }

  -- Essentials
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-unimpaired'
  use 'mbbill/undotree'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use {
    'numToStr/Comment.nvim',
    config = setup('Comment')
  }

  use {
    'windwp/nvim-autopairs',
    config = setup('nvim-autopairs')
  }

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    config = setup('gitsigns')
  }

  -- Syntax analysis
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = configfile('treesitter')
  }

  -- Pretty bars
  use {
    'nvim-lualine/lualine.nvim',
    wants = 'nvim-web-devicons',
    requires = {
      'nvim-tree/nvim-web-devicons', opt = true
    },
    config = setup('lualine')
  }

  -- Colorscheme
  use "EdenEast/nightfox.nvim"
  use "Shirk/vim-gas"

  -- LSP configuration
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = configfile("null_ls")
  }
  use {
    'neovim/nvim-lspconfig',
    config = configfile('lspconfig')
  }
  use {
    'RRethy/vim-illuminate',
    config = function()
      local illum = require 'illuminate'
      vim.keymap.set('n', '<C-n>', illum.goto_next_reference)
      vim.keymap.set('n', '<C-p>', illum.goto_prev_reference)
    end,
  }
  use {
    'folke/neodev.nvim'
  }

  use {
      "hedyhli/outline.nvim",
      config = function()
        vim.keymap.set("n", "<leader>v", "<cmd>Outline<cr>")
        require("outline").setup {
        }
      end
  }

  -- Completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use {
    'hrsh7th/nvim-cmp',
    config = configfile('cmp')
  }
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'

  -- Snippets
  use 'hrsh7th/vim-vsnip'

  -- Telescope (extension config is done in the config.telescope module)
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = configfile('telescope')
  }
  use { 'nvim-telescope/telescope-ui-select.nvim' }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    "de-passage/telescope-makefile",
    requires = {
      { "akinsho/toggleterm.nvim" },
      { 'nvim-telescope/telescope.nvim' }
    },
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }

  -- Terminal
  use {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = configfile('toggleterm')
  }

  use {
    'github/copilot.vim',
    config = configfile('copilot')
  }

  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate",
    config = configfile('mason')
  }

  use 'purescript-contrib/purescript-vim'

  -- Debugger support
  use 'mfussenegger/nvim-dap'
  use {
    'theHamsta/nvim-dap-virtual-text',
    requires = {
       { "mfussenegger/nvim-dap" },
    },
  }

  use {
    'rcarriga/nvim-dap-ui',
    requires = {
      { "mfussenegger/nvim-dap" },
    },
  }

  use {
    "leoluz/nvim-dap-go",
    config = setup('dap-go'),
    requires = {
      { "mfussenegger/nvim-dap" },
    },
  }

  use {
    'RaafatTurki/hex.nvim',
    config = setup('hex')
  }

end)
