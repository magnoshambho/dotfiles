-- ~/.config/nvim/lua/mini/plugins/fuzzy.lua
-- Configuration for mini.fuzzy - fuzzy matching functionality

local loader = require('mini.loader')

loader.load_later('fuzzy', function()
  return require('mini.fuzzy').setup({
    -- Maximum allowed value for match score (works better when not very big)
    cutoff = 100,
    
    -- Function which computes match score for a fuzzy match.
    -- For details see |MiniExtra.fuzzy_match()|.
    matcher = nil,
  })
end)

return true
