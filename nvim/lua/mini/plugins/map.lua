-- ~/.config/nvim/lua/mini/plugins/map.lua
-- Configuration for mini.map

local loader = require('mini.loader')

loader.load_later('map', function()
  -- Set up minimap with integrations
  local setup = require('mini.map').setup({
    symbols = { encode = require('mini.map').gen_encode_symbols.dot('4x2') },
    integrations = { 
      require('mini.map').gen_integration.builtin_search(),
      require('mini.map').gen_integration.diagnostic(),
    },
  })
  
  -- Create autocommand to refresh minimap when diagnostics change
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = function()
      -- Only proceed if mini.map is fully loaded and the MiniMap global exists
      if package.loaded['mini.map'] and _G.MiniMap then
        -- Safely check if is_open function exists and call it
        local success, is_open = pcall(function() return MiniMap.is_open() end)
        -- Only refresh if the is_open call succeeded and returned true
        if success and is_open then
          pcall(MiniMap.refresh)
        end
      end
    end,
  })
  
  return setup
end)

return true
