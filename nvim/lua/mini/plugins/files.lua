-- ~/.config/nvim/lua/mini/plugins/files.lua
-- Configuration for mini.files

local loader = require('mini.loader')

loader.load_later('files', function()
  return require('mini.files').setup({
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 40,
    },
    options = {
      use_as_default_explorer = true,
    }
  })
end)

return true
