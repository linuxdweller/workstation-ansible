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
      local go_format = require("go.format")
      -- Run gofmt + goimport on save.
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = go_format.goimport
      })
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
      local telescope_actions = require('telescope.actions')
      local telescope_actions_state = require('telescope.actions.state')
      require('telescope').setup({
        pickers = {
          -- Jump to a line number when picking files.
          -- Search for filename:80 to jump directly to line 80.
          -- See https://gitter.im/nvim-telescope/community?at=6113b874025d436054c468e6
          find_files = {
            on_input_filter_cb = function(prompt)
              local find_colon = string.find(prompt, ":")
              if find_colon then
                local ret = string.sub(prompt, 1, find_colon - 1)
                vim.schedule(function()
                  local prompt_bufnr = vim.api.nvim_get_current_buf()
                  local picker = telescope_actions_state.get_current_picker(prompt_bufnr)
                  local lnum = tonumber(prompt:sub(find_colon + 1))
                  if type(lnum) == "number" then
                    local win = picker.previewer.state.winid
                    local bufnr = picker.previewer.state.bufnr
                    local line_count = vim.api.nvim_buf_line_count(bufnr)
                    vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(lnum, line_count)), 0 })
                  end
                end)
                return { prompt = ret }
              end
            end,
            attach_mappings = function()
              telescope_actions.select_default:enhance {
                post = function()
                  -- if we found something, go to line
                  local prompt = telescope_actions_state.get_current_line()
                  local find_colon = string.find(prompt, ":")
                  if find_colon then
                    local lnum = tonumber(prompt:sub(find_colon + 1))
                    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
                  end
                end,
              }
              return true
            end,
          },
        }
      })

      require("telescope").load_extension("yaml_schema")

      vim.api.nvim_set_keymap("n", "<leader>fy", "<cmd>Telescope yaml_schema<cr>",
        {silent = true, noremap = true}
      )
    end
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.ansiblelint,
          null_ls.builtins.diagnostics.eslint,
          -- Should use either flake8 or black, not both.
          -- null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.diagnostics.stylelint,
          -- Is it actually needed with TSServer?
          -- null_ls.builtins.diagnostics.tsc,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.eslint,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylelint,

          -- Null hover generator.
          -- Running vim.lsp.buf.hover() errors when there is no language server
          -- supporting hover attached.
          -- Having a generator respond with empty hovers prevents that error.
          {
            name = "hover.null",
            method = null_ls.methods.HOVER,
            filetypes = {},
            generator = {
              fn = function(_, done)
                done({})
              end
            }
          }
        }
      })
    end
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "dockerfile", "go", "hcl", "html", "javascript", "json", "python", "scss", "toml", "typescript", "tsx", "yaml" }
      })
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
      require('indent_blankline').setup({
        char = '▏',
        show_current_context = true
      })
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
