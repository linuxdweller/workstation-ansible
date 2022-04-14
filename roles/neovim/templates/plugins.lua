return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'nvim-treesitter/nvim-treesitter'
  use 'ray-x/go.nvim'

  use "EdenEast/nightfox.nvim"

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  "luukvbaal/nnn.nvim",
    config = function() require("nnn").setup() end
  }

  use {
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function()
      require('mini.comment').setup()
      require('mini.cursorword').setup({
        delay = 0
      })
      require('mini.indentscope').setup({
        delay = 0,
        animation = require('mini.indentscope').gen_animation('none'),
        symbol = '▏'
      })
      require('mini.pairs').setup({
        mappings = {
          ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].'},
          ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].'}
        }
      })
      require('mini.surround').setup()
    end
  }
end)
