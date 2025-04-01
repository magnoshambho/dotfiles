-- ~/.config/nvim/lua/mini/plugins/surround.lua
-- Configuration for mini.surround

local loader = require('mini.loader')

loader.load_later('surround', function()
  -- mini.surround with custom mappings to avoid conflicts
  return require('mini.surround').setup({
    -- Change default mappings to use z prefix instead of s (which conflicts with vim's substitute)
    mappings = {
      add = 'za',      -- Changed from 'sa'
      delete = 'zd',   -- Changed from 'sd'
      find = 'zf',     -- Changed from 'sf'
      find_left = 'zF', -- Changed from 'sF'
      highlight = 'zh', -- Changed from 'sh'
      replace = 'zr',   -- Changed from 'sr'
      update_n_lines = 'zn', -- Changed from 'sn'
    },
  })
end)

return true
