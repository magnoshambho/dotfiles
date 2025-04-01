-- ~/.config/nvim/lua/mini/plugins/operators.lua
-- Configuration for mini.operators

local loader = require('mini.loader')

loader.load_later('operators', function()
  return require('mini.operators').setup({
    -- Default mappings:
    -- g= - Evaluate text and replace (like lua expressions)
    -- gm - Replace with register content
    -- gM - Exchange text
    -- gs - Sort text
    -- g/ - Replace text with input
    -- gz - Execute commands on text
  })
end)

return true
