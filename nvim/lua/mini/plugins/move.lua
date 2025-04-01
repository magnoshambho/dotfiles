-- ~/.config/nvim/lua/mini/plugins/move.lua
-- Configuration for mini.move

local loader = require('mini.loader')

loader.load_later('move', function()
  return require('mini.move').setup({
    -- Disable reindent to preserve existing indentation
    options = { reindent_linewise = false },
    -- Default mappings: Alt+hjkl to move selections/lines
  })
end)

return true
