-- ~/.config/nvim/lua/mini/plugins/splitjoin.lua
-- Configuration for mini.splitjoin

local loader = require('mini.loader')

loader.load_later('splitjoin', function()
  return require('mini.splitjoin').setup({
    -- Default mapping: gS to toggle between single and multi-line forms
  })
end)

return true
