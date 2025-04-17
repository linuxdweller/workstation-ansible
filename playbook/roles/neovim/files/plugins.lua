return {
  -- TODO: Add https://github.com/xzbdmw/colorful-menu.nvim
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp"
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = {
        "ansiblels",
        "astro",
        "clangd",
        "dockerls",
        "gopls",
        "helm_ls",
        "pyright",
        "tailwindcss",
        "terraformls",
        "tilt_ls",
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
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition." },
      { "<leader>fr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "<leader>ft", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    },
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets",  "xzbdmw/colorful-menu.nvim", "nvim-lua/plenary.nvim" },
    version = "v0.*",
    opts = {
      keymap = {
        preset = "super-tab"
      },
      completion = {
        documentation = {
          treesitter_highlighting = true,
          window = { border = 'single' },
          auto_show = true,
        },
        menu = {
          border = 'single',
          draw = {
            columns = { { "source_name" }, { "kind_icon", "kind" }, { "label", gap = 1 } },
          }
        }
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
    -- Specify for lazy the main module to use for config() and opts().
    main = "nvim-treesitter.configs",
    -- Lazy will execute this on install or update of the plugin.
    -- We want to update our parsers when the plugin is updated or installed.
    build = ":TSUpdate",
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
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      highlight = {
        -- Enable the sytax highlighting module. All modules are disabled by default.
        enable = true,
      },
    }
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
      -- Required for eslint_d and prettierd sources.
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        on_attach = function(client, bufnr)
        -- Source: https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save
        -- Format on save:
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
          end
        end,
        sources = {
          null_ls.builtins.diagnostics.ansiblelint,
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.formatting.biome,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.packer,
          null_ls.builtins.formatting.terraform_fmt
        }
      })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      vim.api.nvim_set_keymap("n", "<leader>ha", "<cmd>Gitsigns stage_hunk<cr>",
        {silent = true, noremap = true}
      )
      vim.api.nvim_set_keymap("v", "<leader>ha", "<cmd>Gitsigns stage_hunk<cr>",
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
  "tpope/vim-sleuth"
}
