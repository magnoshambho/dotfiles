-- ~/.config/nvim/lua/mini/plugins/bracketed.lua
-- Configuration for mini.bracketed

local loader = require('mini.loader')

loader.load_later('bracketed', function()
  return require('mini.bracketed').setup({
    -- Default setup provides mappings like [b/]b for buffers,
    -- [l/]l for locations, etc.
  })
end)

return true
