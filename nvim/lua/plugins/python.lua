-- Add this to plugins/init.lua inside the servers table
-- or create a new file at lua/plugins/python.lua

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
    },
  },
}

-- Python-specific settings
local python_on_attach = function(client, bufnr)
  -- Set buffer-local options that help with completion
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  
  -- Enhanced tab completion behavior for Python
  vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-n>'
    elseif vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2]):match('%s*$') then
      return '<Tab>'
    else
      return vim.fn['mini.completion'].complete_or_jump()
    end
  end, { expr = true, buffer = bufnr })
  
  -- Show signature help when typing opening parenthesis
  vim.keymap.set('i', '(', function()
    vim.schedule(function()
      vim.lsp.buf.signature_help()
    end)
    return '('
  end, { expr = true, buffer = bufnr })
  
  -- Improve method completion experience when typing dot
  vim.keymap.set('i', '.', function()
    vim.schedule(function()
      if vim.fn['mini.completion'].completefunc_lsp(1, '') ~= 0 then
        vim.fn.complete(vim.fn.col('.'), {})
      end
    end)
    return '.'
  end, { expr = true, buffer = bufnr })
end

-- Update the Pyright configuration
-- If you have a servers table in plugins/init.lua, modify it like this:
servers.pyright = {
  settings = pyright_settings,
  on_attach = function(client, bufnr)
    -- Call the common on_attach first
    on_attach(client, bufnr)
    -- Then call Python-specific on_attach
    python_on_attach(client, bufnr)
  end,
}
