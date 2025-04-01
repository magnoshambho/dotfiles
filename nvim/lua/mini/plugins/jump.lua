-- ~/.config/nvim/lua/mini/plugins/jump.lua
-- Configuration for mini.jump - Enhanced multi-line f/F/t/T jumps

local loader = require('mini.loader')

loader.load_later('jump', function()
  return require('mini.jump').setup({
    -- Module mappings. Use '' (empty string) to disable one.
    mappings = {
      forward = 'f',
      backward = 'F',
      forward_till = 't',
      backward_till = 'T',
      repeat_jump = ';',
    },

    -- Delay values (in ms) for different functionalities
    delay = {
      -- Delay between jump and highlighting all possible jumps
      highlight = 250,

      -- Delay between jump and automatic stop if idle (no jump is done)
      -- Using a very high value effectively disables this feature
      idle_stop = 10000000,
    },

    -- Whether to disable showing non-error feedback
    silent = false,
  })
end)

-- Set a more distinguishable highlight for MiniJump
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Create a more visible highlight that works with both light and dark themes
    local hi = vim.api.nvim_get_hl(0, { name = 'Search' })
    local bg = hi.bg or hi.background
    
    if bg then
      -- Use Search's background but with reduced opacity
      vim.api.nvim_set_hl(0, 'MiniJump', {
        bg = bg,
        blend = 40,  -- 40% opacity
        bold = true
      })
    else
      -- Fallback if Search bg is not available
      vim.api.nvim_set_hl(0, 'MiniJump', {
        reverse = true,
        bold = true,
        blend = 40
      })
    end
  end
})

-- Apply highlight immediately
vim.api.nvim_exec_autocmds('ColorScheme', { pattern = '*' })

return true
