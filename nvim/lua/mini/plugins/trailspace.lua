-- ~/.config/nvim/lua/mini/plugins/trailspace.lua
-- Configuration for mini.trailspace

local loader = require('mini.loader')

loader.load_later('trailspace', function()
  return require('mini.trailspace').setup({
    -- Default configuration highlights trailing whitespace
    -- Use <Leader>ws to trim trailing whitespace (set in keymaps.lua)
  })
end)

return true
