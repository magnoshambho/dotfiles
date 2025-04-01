-- ~/.config/nvim/lua/plugins/init.lua
-- Configuration for external plugins (non mini.nvim)

return now(function()
  -- Treesitter for advanced syntax highlighting
  MiniDeps.add('nvim-treesitter/nvim-treesitter')
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'lua', 'vim', 'vimdoc', 'python', 'rust',
      'bash', 'c', 'cpp', 'markdown', 'json', 'toml', 'yaml',
    },
    highlight = { 
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<S-TAB>',
      },
    },
  })

  -- Completion plugin and dependencies
  -- Load these first so cmp_nvim_lsp is available for LSP config
  MiniDeps.add('hrsh7th/nvim-cmp')
  MiniDeps.add('hrsh7th/cmp-nvim-lsp')
  MiniDeps.add('hrsh7th/cmp-buffer')
  MiniDeps.add('hrsh7th/cmp-path')
  MiniDeps.add('hrsh7th/cmp-cmdline')
  MiniDeps.add('L3MON4D3/LuaSnip')
  MiniDeps.add('saadparwaiz1/cmp_luasnip')

  -- Mason for LSP, formatters and linters management
  MiniDeps.add('williamboman/mason.nvim')
  MiniDeps.add('williamboman/mason-lspconfig.nvim')
  MiniDeps.add('neovim/nvim-lspconfig')
  
  require('mason').setup({
    ui = {
      border = 'double',
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })
  
  require('mason-lspconfig').setup({
    ensure_installed = {
      'lua_ls', 'pyright', 'rust_analyzer',
    },
    automatic_installation = true,
  })
  
  -- LSP Configuration
  local lspconfig = require('lspconfig')
  
  -- Common configuration for all servers
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Diagnostics on hover
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })
  end
  
  -- Get capabilities from cmp_nvim_lsp if available
  local capabilities
  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities()
  else
    capabilities = vim.lsp.protocol.make_client_capabilities()
  end
  
  -- Server-specific settings
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'MiniDeps', 'now', 'later', 'add' }
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        }
      }
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true
          }
        }
      }
    },
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            command = "clippy"
          },
          cargo = {
            allFeatures = true,
          },
        }
      }
    }
  }
  
  -- Configure each server
  for server_name, config in pairs(servers) do
    config.on_attach = on_attach
    config.capabilities = capabilities
    lspconfig[server_name].setup(config)
  end

  -- Setup nvim-cmp
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
    }),
    window = {
      documentation = {
        border = 'double',
      },
      completion = {
        border = 'double',
      }
    },
    formatting = {
      format = function(entry, vim_item)
        -- Add source names
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end
    }
  })
  
  -- Command line completion setup
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  
  -- Search completion setup
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
end)
