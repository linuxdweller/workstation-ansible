return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      local lspconfig = require('lspconfig')
      local servers = { 'tsserver', 'gopls', 'pyright', 'dockerls', 'terraformls' }
      for _, lsp in pairs(servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities
        }
      end
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' }
      })
      local yamlConfig = require('yaml-companion').setup()
      lspconfig.yamlls.setup(yamlConfig)
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
      vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

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

  -- Diagnostics viewer.
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
      vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
        {silent = true, noremap = true}
      )
    end
  }

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
  use {
    'EdenEast/nightfox.nvim',
    config = function()
      vim.cmd('colorscheme nightfox')
    end
  }

  -- Search window.
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    },
    config = function()
      require('telescope').load_extension('fzf')

      vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", {noremap = true})

      vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').command_history()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fc', "<cmd>lua require('telescope.builtin').commands()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>fo', "<cmd>lua require('telescope.builtin').oldfiles()<cr>", {noremap = true})
    end
  }

  use {
    "someone-stole-my-name/yaml-companion.nvim",
    requires = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" }
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
      vim.api.nvim_set_keymap("n", "<leader>fy", "<cmd>Telescope yaml_schema<cr>",
        {silent = true, noremap = true}
      )
    end
  }

  -- File browser.
  use {
    "luukvbaal/nnn.nvim",
    config = function()
      require("nnn").setup()
      vim.api.nvim_set_keymap('n', '<leader>nn', "<cmd>NnnPicker<cr>", {noremap = true})
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release',
    config = function()
      require('gitsigns').setup()
      vim.api.nvim_set_keymap("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>",
        {silent = true, noremap = true}
      )
    end
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
