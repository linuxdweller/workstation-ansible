return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      local servers = { 'tsserver', 'gopls', 'dockerls', 'yamlls' }
      for _, lsp in pairs(servers) do
        require('lspconfig')[lsp].setup {
          capabilities = capabilities
        }
      end
    end
  }
 
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          -- Recommended keymap.
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          -- Use tab to select next item.
          ['<Tab>'] = cmp.mapping.select_next_item()
        }),
        sources = cmp.config.sources({
          { name = 'nvim-lsp'},
          { name = 'vsnip' }
        }, {
          { name = 'buffer' }
        })
      })
    end
  }

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  -- Go laungauge integration.
  use {
    'ray-x/go.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('go').setup()
      require("go.format").goimport()
      -- Run gofmt + goimport on save.
      vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
    end
  }

  -- Theme.
  use "EdenEast/nightfox.nvim"

  -- Search window.
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
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

  -- Automatic indenent detection.
  use 'tpope/vim-sleuth'
end)
