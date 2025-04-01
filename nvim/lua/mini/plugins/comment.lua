-- ~/.config/nvim/lua/mini/plugins/comment.lua
-- Configuration for mini.comment

local loader = require('mini.loader')

loader.load_later('comment', function()
  return require('mini.comment').setup({
    -- Default mappings: 'gc' for regular comments (gcc for line)
    -- and 'gbc' for block comments
  })
end)

return true
