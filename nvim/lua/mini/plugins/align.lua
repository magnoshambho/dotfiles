-- ~/.config/nvim/lua/mini/plugins/align.lua
-- Configuration for mini.align

local loader = require('mini.loader')

loader.load_later('align', function()
  return require('mini.align').setup({
    -- Default mappings: 'ga' in normal and visual modes
    -- Provides interactive alignment by various delimiters
  })
end)

return true
