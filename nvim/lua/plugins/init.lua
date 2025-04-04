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
  
  -- Basic capabilities without cmp_nvim_lsp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
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

  -- Python method completion
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      -- Enhanced way to show method completion after dot
      vim.keymap.set('i', '.', function()
        -- Insert dot first
        vim.api.nvim_put({''}, 'c', false, true)
        
        -- Then trigger completion with a slight delay
        vim.schedule(function()
          -- Try different methods to ensure completion works
          if vim.lsp.buf.completion then
            vim.lsp.buf.completion()
          else
            -- Fall back to omnifunc
            local col = vim.fn.col('.')
            vim.fn.complete(col, vim.lsp.omnifunc(1, ''))
          end
        end)
        
        -- Return the dot character
        return '.'
      end, { expr = true, buffer = true })
    end
  })
end)

