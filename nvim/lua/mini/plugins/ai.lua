-- ~/.config/nvim/lua/mini/plugins/ai.lua
-- Configuration for mini.ai

local loader = require('mini.loader')

loader.load_later('ai', function()
  return require('mini.ai').setup({
    -- No custom configuration needed, default mappings work well
    -- This provides text objects like ia, aa (for arguments) 
    -- and if, af (for functions), etc.
  })
end)

return true
