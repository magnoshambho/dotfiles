-- ~/.config/nvim/lua/mini/plugins/indentscope.lua
-- Configuration for mini.indentscope

local loader = require('mini.loader')

loader.load_later('indentscope', function()
  return require('mini.indentscope').setup({
    symbol = '│',
    options = { try_as_border = true }
  })
end)

return true
