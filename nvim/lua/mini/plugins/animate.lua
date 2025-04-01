-- ~/.config/nvim/lua/mini/plugins/animate.lua
-- Configuration for mini.animate

local loader = require('mini.loader')

loader.load_later('animate', function()
  return require('mini.animate').setup({
    -- Disable scroll animations for better performance
    scroll = { enable = false },
    -- Keep other animations for window creation/resizing
  })
end)

return true
