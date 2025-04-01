-- ~/.config/nvim/lua/mini/plugins/bufremove.lua
-- Configuration for mini.bufremove - Remove buffers without breaking layout

local loader = require('mini.loader')

loader.load_later('bufremove', function()
  return require('mini.bufremove').setup({
    -- Whether to set Vim's settings for buffers (allow hidden buffers)
    set_vim_settings = true,
    
    -- Whether to disable showing non-error feedback
    silent = false,
  })
end)

-- Add keymappings for buffer removal
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only add these when MiniBufremove is available
    if _G.MiniBufremove then
      -- Keymaps using Leader + b prefix (buffer)
      vim.keymap.set('n', '<Leader>bd', function()
        MiniBufremove.delete()
      end, { desc = 'Delete buffer' })
      
      vim.keymap.set('n', '<Leader>bD', function()
        MiniBufremove.delete(0, true)  -- Force delete even with unsaved changes
      end, { desc = 'Force delete buffer' })
      
      vim.keymap.set('n', '<Leader>bw', function()
        MiniBufremove.wipeout()
      end, { desc = 'Wipeout buffer' })
      
      vim.keymap.set('n', '<Leader>bW', function()
        MiniBufremove.wipeout(0, true)  -- Force wipeout even with unsaved changes
      end, { desc = 'Force wipeout buffer' })
    end
  end
})

return true
