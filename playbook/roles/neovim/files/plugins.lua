return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp"
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = {
        "ansiblels",
        "astro",
        "clangd",
        "dockerls",
        "emmet_ls",
        "gopls",
        "helm_ls",
        "pyright",
        "tailwindcss",
        "terraformls",
        "tilt_ls",
        "ts_ls",
        "yamlls",
      }
      for _, lsp in pairs(servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities
        }
      end
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope_actions = require('telescope.actions')
      local telescope_actions_state = require('telescope.actions.state')
      require('telescope').setup({})
      require('telescope').load_extension('fzf')
      builtin = require('telescope.builtin')

      vim.api.nvim_set_keymap('n', '<leader>ff', "", {noremap = true, callback = builtin.find_files})
      vim.api.nvim_set_keymap('n', '<leader>fg', "", {noremap = true, callback = builtin.live_grep})
      vim.api.nvim_set_keymap('n', '<leader>fb', "", {noremap = true, callback = builtin.current_buffer_fuzzy_find})

      vim.api.nvim_set_keymap('n', '<leader>fh', "", {noremap = true, callback = builtin.command_history})
      vim.api.nvim_set_keymap('n', '<leader>fc', "", {noremap = true, callback = builtin.commands})
      vim.api.nvim_set_keymap('n', '<leader>fr', "", {noremap = true, callback = builtin.lsp_references})
      vim.api.nvim_set_keymap('n', '<leader>fd', "", {noremap = true, callback = builtin.lsp_definitions})
      vim.api.nvim_set_keymap('n', '<leader>fi', "", {noremap = true, callback = builtin.lsp_implementations})
      vim.api.nvim_set_keymap('n', '<leader>fo', "", {noremap = true, callback = builtin.oldfiles})
    end
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v0.*",
    opts = {
      keymap = {
        preset = "super-tab"
      }
    }
  },
  {
    "folke/trouble.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons"
    },
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
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "gitcommit",
        "go",
        "gotmpl",
        "hcl",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "scss",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      textobjects = {
        -- For more queries see:
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/master/queries
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer" },
            ["if"] = { query = "@function.inner" },
            ["ac"] = { query = "@class.outer" },
            ["ic"] = { query = "@class.inner" },
            ["al"] = { query = "@loop.outer" },
            ["il"] = { query = "@loop.inner" },
            ["ai"] = { query = "@conditional.outer"},
            ["ii"] = { query = "@conditional.inner"},
            ["ab"] = { query = "@block.outer" },
            ["ib"] = { query = "@block.inner" },
            ["a/"] = { query = "@comment.outer" },
            ["i/"] = { query = "@comment.inner" },
            ["as"] = { query = "@scope", query_group = "locals" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>]p"] = { query = "@parameter.inner" },
            ["<leader>]m"] = { query = "@function.outer" },
            ["<leader>]]"] = { query = "@class.outer" },
            ["<leader>]l"] = { query = "@loop.outer" },
            ["<leader>]i"] = { query = "@conditional.outer" },
          },
          swap_previous = {
            ["<leader>[p"] = { query = "@parameter.inner" },
            ["<leader>[m"] = { query = "@function.outer" },
            ["<leader>[]"] = { query = "@class.outer" },
            ["<leader>[l"] = { query = "@loop.outer" },
            ["<leader>[i"] = { query = "@conditional.outer" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]p"] = { query = "@parameter.inner" },
            ["]m"] = { query = "@function.inner" },
            ["]]"] = { query = "@class.inner", desc = "Next class start" },
            ["]l"] = { query = "@loop.inner" },
            ["]i"] = { query = "@conditional.inner" },
          },
          goto_next_end = {
            ["]P"] = { query = "@parameter.inner" },
            ["]M"] = { query = "@function.inner" },
            ["]["] = { query = "@class.inner" },
            ["]L"] = { query = "@loop.inner" },
            ["]I"] = { query = "@conditional.inner" },
          },
          goto_previous_start = {
            ["[p"] = { query = "@parameter.inner" },
            ["[m"] = { query = "@function.inner" },
            ["[["] = { query = "@class.inner" },
            ["[l"] = { query = "@loop.inner" },
            ["[i"] = { query = "@conditional.inner" },
          },
          goto_previous_end = {
            ["[P"] = { query = "@parameter.inner" },
            ["[M"] = { query = "@function.inner" },
            ["[]"] = { query = "@class.inner" },
            ["[L"] = { query = "@loop.inner" },
            ["[I"] = { query = "@conditional.inner" },
          }
        },
      }
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
      require("catppuccin").setup({
        integrations = {
          blink_cmp = true
        }
      })
      vim.api.nvim_command("colorscheme catppuccin")
    end
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.ansiblelint,
          require("none-ls.diagnostics.eslint"),
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.formatting.black,
          require("none-ls.formatting.eslint"),
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.packer,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylelint,
          null_ls.builtins.formatting.terraform_fmt
        }
      })
      -- Format files on save.
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go,*.py,*.[jt]s,*.[jt]sx,*.css,*.s[ac]ss,*.json,*.yaml,*.yml,*.md,*.tf,*.hcl',
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              return client.name == 'null-ls'
            end
          })
        end
      })
    end
  },
  {
    "luukvbaal/nnn.nvim",
    config = function()
      require("nnn").setup()
      vim.api.nvim_set_keymap("n", "<leader>nn", "<cmd>NnnPicker<cr>", {noremap = true})
    end
  },
  {
    "echasnovski/mini.nvim",
    branch = "stable",
    config = function()
      require("mini.comment").setup()
      require("mini.cursorword").setup({
        delay = 0
      })
      require("mini.pairs").setup()
      require("mini.diff").setup({
        view = {
          style = "number"
        }
      })
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    config = true
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    version = "*",
    main = "ibl",
    opts = {
      indent = {
        char = "▏"
      },
      scope = {
        enabled = false
      }
    }
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end
  },
  "tpope/vim-sleuth"
}
