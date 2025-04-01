-- ~/.config/nvim/lua/mini/plugins/icons.lua
-- Configuration for mini.icons and color settings

local loader = require('mini.loader')

loader.load_now('icons', function()
  -- mini.icons - custom icons
  local custom_icons = {
    -- File types
    ['lua'] = { icon = '', color = '#51a0cf' },
    ['py'] = { icon = '', color = '#ffbc03' },
    ['rs'] = { icon = '', color = '#dea584' },
    
    -- Folders
    ['folder'] = { icon = '', color = '#7ebae4' },
    ['folder_open'] = { icon = '', color = '#7ebae4' },
    
    -- UI elements
    ['error'] = { icon = '', color = '#ea6962' },
    ['warn'] = { icon = '', color = '#d8a657' },
    ['info'] = { icon = '', color = '#7daea3' },
    ['hint'] = { icon = '', color = '#a9b665' },
    
    -- Git status
    ['git_added'] = { icon = '', color = '#a9b665' },
    ['git_modified'] = { icon = '', color = '#d8a657' },
    ['git_removed'] = { icon = '', color = '#ea6962' },
  }
  
  local setup = require('mini.icons').setup({
    icons = custom_icons,
    use = {
      files = true,
      diagnostics = true,
      git = true,
      statusline = true,
      tabline = true,
    },
    fallback = {
      icon = '',
      warn = false,
    },
  })
  
  -- Color configuration
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { link = 'Statusline', default = true })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { link = 'String', default = true })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { link = 'Statement', default = true })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { link = 'Error', default = true })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { link = 'IncSearch', default = true })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { link = 'NonText', default = true })
      
      vim.api.nvim_set_hl(0, 'MiniHipatternsFixme', { fg = '#ea6962', bold = true })
      vim.api.nvim_set_hl(0, 'MiniHipatternsHack', { fg = '#d8a657', bold = true })
      vim.api.nvim_set_hl(0, 'MiniHipatternsNote', { fg = '#a9b665', bold = true })
    end,
  })
  
  -- Set color scheme
  vim.cmd('colorscheme minischeme')
  
  return setup
end)

return true
