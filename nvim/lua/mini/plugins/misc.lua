-- ~/.config/nvim/lua/mini/plugins/misc.lua
-- Configuration for mini.misc - Collection of miscellaneous utilities

local loader = require('mini.loader')

loader.load_later('misc', function()
  local setup = require('mini.misc').setup({
    -- Array of fields to make global (to be used as independent variables)
    make_global = { 'put', 'put_text', 'zoom' },
  })
  
  -- Set up automated terminal background color synchronization
  -- Removes the "frame" around Neovim in terminals supporting OSC 11
  MiniMisc.setup_termbg_sync()
  
  -- Set up automatic cursor restoration on file reopening
  MiniMisc.setup_restore_cursor()
  
  -- Set up auto-root to auto-cd to project directory
  -- This automatically changes directory to project root when entering a buffer
  MiniMisc.setup_auto_root({ '.git', 'Makefile', 'pyproject.toml', 'Cargo.toml', 'package.json' })
  
  -- Enable nested comments for better formatting
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
      MiniMisc.use_nested_comments()
    end
  })
  
  return setup
end)

-- Create keymappings for misc functionality
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if _G.MiniMisc then
      -- Zoom buffer
      vim.keymap.set('n', '<Leader>z', function()
        MiniMisc.zoom()
      end, { desc = 'Zoom buffer' })
      
      -- Find gutter width (useful for some UI calculations)
      vim.keymap.set('n', '<Leader>mg', function()
        local width = MiniMisc.get_gutter_width()
        vim.notify('Gutter width: ' .. width, vim.log.levels.INFO)
      end, { desc = 'Get gutter width' })
      
      -- Resize window to textwidth
      vim.keymap.set('n', '<Leader>mr', function()
        MiniMisc.resize_window()
      end, { desc = 'Resize to textwidth' })
      
      -- Print Lua objects (for debugging)
      vim.keymap.set('n', '<Leader>mp', function()
        -- Example usage showing current buffer info
        local bufnr = vim.api.nvim_get_current_buf()
        local info = {
          name = vim.api.nvim_buf_get_name(bufnr),
          filetype = vim.bo[bufnr].filetype,
          lines = vim.api.nvim_buf_line_count(bufnr),
          modified = vim.bo[bufnr].modified
        }
        MiniMisc.put(info)
      end, { desc = 'Print buffer info' })
      
      -- Benchmarking helper
      vim.keymap.set('n', '<Leader>mb', function()
        -- Example benchmarking a simple function
        local results = MiniMisc.bench_time(function(x) return x * x end, 1000, 42)
        MiniMisc.put('Benchmark results:')
        MiniMisc.put(MiniMisc.stat_summary(results))
      end, { desc = 'Run benchmark' })
    end
  end
})

return true
