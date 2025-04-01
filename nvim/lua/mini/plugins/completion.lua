-- ~/.config/nvim/lua/mini/plugins/completion.lua
-- Configuration for mini.completion

local loader = require('mini.loader')

loader.load_later('completion', function()
  -- Since nvim-cmp has been removed, always setup mini.completion
  local setup = require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
    },
    window = {
      info = { border = 'double' },
      signature = { border = 'double' },
    },
  })
  
  -- Add keybindings for completion
  vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
  
  return setup
end)

return true
