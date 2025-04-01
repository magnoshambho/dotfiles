-- ~/.config/nvim/lua/mini/plugins/basics.lua
-- Configuration for mini.basics

local loader = require('mini.loader')

loader.load_now('basics', function()
  return require('mini.basics').setup({
    options = {
      basic = true,
      win_borders = 'double',
      extra_ui = true
    },
    mappings = {
      -- Disable basic mappings to avoid conflicts with custom ones
      basic = false,
      -- Keep window/movement mappings
      windows = true,
      move_lines = true,
      -- Disable prefix mappings which conflict with our <Leader> mappings
      prefix = false
    },
    autocommands = {
      basic = true,
      relnum_in_visual_mode = true,
    },
    plugin_friendly = true
  })
end)

return true
