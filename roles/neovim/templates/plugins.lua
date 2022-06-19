return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      local lspconfig = require('lspconfig')
      local servers = { 'tsserver', 'gopls', 'pyright', 'dockerls', 'yamlls', 'terraformls' }
      for _, lsp in pairs(servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities
        }
      end
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' }
      })
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
          { name = 'nvim_lsp'},
          { name = 'vsnip' }
        }, {
          { name = 'buffer' }
        })
      })
    end
  }

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'

  -- Snippets for many languages.
  use "rafamadriz/friendly-snippets"

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
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    },
    config = function()
      require('telescope').load_extension('fzf')
    end
  }

  -- File browser.
  use {
    "luukvbaal/nnn.nvim",
    config = function() require("nnn").setup() end
  }

  -- Commenting/uncommenting, highlight of word under the cursor, bracket pairing and surrounding.
  use {
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function()
      require('mini.comment').setup()
      require('mini.cursorword').setup({
        delay = 0
      })
      require('mini.pairs').setup({
        mappings = {
          ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].'},
          ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].'}
        }
      })
      require('mini.surround').setup({
        mappings = {
          add = '<leader>sa', -- Add surrounding
          delete = '<leader>sd', -- Delete surrounding
          find = '<leader>sf', -- Find surrounding (to the right)
          find_left = '<leader>sF', -- Find surrounding (to the left)
          highlight = '<leader>sh', -- Highlight surrounding
          replace = '<leader>sr', -- Replace surrounding
          update_n_lines = '<leader>sn', -- Update `n_lines`
        },
      })
    end
  }

  -- Indent guide.
  use {
    'lukas-reineke/indent-blankline.nvim',
    tag = 'v2.18.4',
    config = function()
      require('indent_blankline').setup()
    end
  }

  -- Automatic indenent detection.
  use 'tpope/vim-sleuth'

  -- Motion.
  use {
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end
  }

  -- Smooth scrolling.
  use {
    'declancm/cinnamon.nvim',
    config = function()
      require('cinnamon').setup()
    end
  }
end)
