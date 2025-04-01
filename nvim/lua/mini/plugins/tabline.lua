-- ~/.config/nvim/lua/mini/plugins/tabline.lua
-- Configuration for mini.tabline

local loader = require('mini.loader')

loader.load_now('tabline', function()
  return require('mini.tabline').setup({
    -- Default configuration for the tabline
    -- Shows both buffers and tabs in the tabline
  })
end)

return true
