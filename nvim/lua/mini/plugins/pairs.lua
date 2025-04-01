-- ~/.config/nvim/lua/mini/plugins/pairs.lua
-- Configuration for mini.pairs

local loader = require('mini.loader')

loader.load_later('pairs', function()
  local setup = require('mini.pairs').setup({
    -- Default configuration for auto-pairing brackets and quotes
  })
  
  -- Integration with mini.surround (if both plugins are loaded)
  if package.loaded['mini.surround'] then
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniSurroundUpdated',
      callback = function()
        -- This is a placeholder for potential custom integration
        -- For now, both plugins will work independently
      end,
    })
  end
  
  return setup
end)

return true
