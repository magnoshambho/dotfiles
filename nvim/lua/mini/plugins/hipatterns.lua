-- ~/.config/nvim/lua/mini/plugins/hipatterns.lua
-- Configuration for mini.hipatterns

local loader = require('mini.loader')

loader.load_later('hipatterns', function()
  return require('mini.hipatterns').setup({
    highlighters = {
      -- Highlight TODO, FIXME, NOTE, etc.
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsFixme" },
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    }
  })
end)

return true
