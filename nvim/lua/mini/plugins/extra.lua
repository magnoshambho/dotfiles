-- ~/.config/nvim/lua/mini/plugins/extra.lua
-- Configuration for mini.extra

local loader = require('mini.loader')

loader.load_later('extra', function()
  return require('mini.extra').setup({
    modules = {
      diagnostics = true,
    }
  })
end)

return true
