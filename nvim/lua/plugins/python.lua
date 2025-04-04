-- Create this file at: ~/.config/nvim/lua/plugins/python.lua

-- Python-specific settings and enhancements
return now(function()
  -- Enhanced Pyright configuration for better method completion
  local pyright_settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        -- Enable completion of import statements
        completeFunctionParens = true,
        -- Improve type information
        typeCheckingMode = "basic",
        -- Increase information available in completion
        inlayHints = {
          functionReturnTypes = true,
          variableTypes = true,
        },
      }
    }
  }

  -- Set up Python-specific autocommands
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      
      -- 1. Enhanced dot completion for Python files
      vim.keymap.set('i', '.', function()
        -- Insert the dot first
        return '.' .. vim.fn['mini.completion'].completefunc_lsp(1, '')
      end, { expr = true, silent = true, buffer = bufnr })
      
      -- 2. Improve parenthesis completion
      vim.keymap.set('i', '(', function()
        -- Schedule signature help after inserting parenthesis
        vim.schedule(function()
          vim.lsp.buf.signature_help()
        end)
        return '('
      end, { expr = true, buffer = bufnr })
      
      -- 3. Fix Tab completion
      vim.keymap.set('i', '<Tab>', function()
        if vim.fn.pumvisible() == 1 then
          return '<C-n>'
        elseif vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2]):match('%s*$') then
          return '<Tab>'
        else
          -- Trigger completion
          vim.fn['mini.completion'].complete_or_jump(1, '')
          return ''
        end
      end, { expr = true, buffer = bufnr })
      
      -- 4. Set buffer-local completion config
      vim.b.minicompletion_config = {
        lsp_completion = {
          -- Use omnifunc for completion
          source_func = 'omnifunc',
          -- Process items to prioritize methods
          process_items = function(items, base)
            -- Sort to prioritize methods
            table.sort(items, function(a, b)
              local a_is_method = a.kind == vim.lsp.protocol.CompletionItemKind.Method or 
                                  a.kind == vim.lsp.protocol.CompletionItemKind.Function
              local b_is_method = b.kind == vim.lsp.protocol.CompletionItemKind.Method or
                                  b.kind == vim.lsp.protocol.CompletionItemKind.Function
              
              -- Show methods first
              if a_is_method and not b_is_method then return true end
              if not a_is_method and b_is_method then return false end
              
              -- Otherwise sort alphabetically
              return (a.sortText or a.label) < (b.sortText or b.label)
            end)
            
            return items
          end,
        },
      }
      
      -- 5. Set Python-specific LSP keymaps
      vim.keymap.set('n', '<Leader>pd', function() vim.lsp.buf.definition() end, 
                    { buffer = bufnr, desc = 'Python: Go to definition' })
      vim.keymap.set('n', '<Leader>pi', function() vim.lsp.buf.implementation() end, 
                    { buffer = bufnr, desc = 'Python: Go to implementation' })
    end
  })

  -- Find and update the Pyright configuration
  if vim.lsp and vim.lsp.get_active_clients then
    local lspconfig = require('lspconfig')
    if lspconfig.pyright then
      lspconfig.pyright.setup({
        settings = pyright_settings,
        on_attach = function(client, bufnr)
          -- Call common on_attach if it exists
          if on_attach then on_attach(client, bufnr) end
          
          -- Set omnifunc for this buffer
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          
          -- Force enable autocompletion for dot
          vim.cmd([[
            augroup PythonDotCompletion
              autocmd! * <buffer>
              autocmd InsertCharPre <buffer> if v:char == '.' | call complete(col('.'), v:lua.vim.lsp.omnifunc(1, '')) | endif
            augroup END
          ]])
        end,
      })
    end
  end
  
  -- Create a global function to trigger Python method completion
  -- This can be called manually if needed
  _G.trigger_python_completion = function()
    if vim.bo.filetype ~= "python" then
      vim.notify("Not a Python file", vim.log.levels.WARN)
      return
    end
    
    local col = vim.fn.col('.')
    vim.fn.complete(col, vim.lsp.omnifunc(1, ''))
  end
end)
