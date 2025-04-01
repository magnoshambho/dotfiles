-- ~/.config/nvim/lua/mini/plugins/visits.lua
-- Configuration for mini.visits - Track and reuse file system visits

local loader = require('mini.loader')

loader.load_later('visits', function()
  return require('mini.visits').setup({
    -- How visit index is converted to list of paths
    list = {
      -- Predicate for which paths to include (all by default)
      filter = nil,
      
      -- Sort paths based on the visit data (robust frecency by default)
      sort = nil,
    },
    
    -- Whether to disable showing non-error feedback
    silent = false,
    
    -- How visit index is stored
    store = {
      -- Whether to write all visits before Neovim is closed
      autowrite = true,
      
      -- Function to ensure that written index is relevant
      -- Use default normalization to forget outdated visits
      normalize = nil,
      
      -- Path to store visit index
      path = vim.fn.stdpath('data') .. '/mini-visits-index',
    },
    
    -- How visit tracking is done
    track = {
      -- Start visit register timer at this event
      event = 'BufEnter',
      
      -- Debounce delay after event to register a visit
      delay = 1000,
    },
  })
end)

-- Add keymappings for visits
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only add these when MiniVisits is available
    if _G.MiniVisits then
      -- Frecent files (frequency + recency balanced)
      vim.keymap.set('n', '<Leader>ff', function()
        MiniVisits.select_path()
      end, { desc = 'Find recent files (frecent)' })
      
      -- Most recently used files
      vim.keymap.set('n', '<Leader>fr', function()
        local sort_recent = MiniVisits.gen_sort.default({ recency_weight = 1 })
        MiniVisits.select_path(nil, { sort = sort_recent })
      end, { desc = 'Find most recent files' })
      
      -- Most frequently used files
      vim.keymap.set('n', '<Leader>fF', function()
        local sort_frequent = MiniVisits.gen_sort.default({ recency_weight = 0 })
        MiniVisits.select_path(nil, { sort = sort_frequent })
      end, { desc = 'Find most frequent files' })
      
      -- Label management
      vim.keymap.set('n', '<Leader>al', function()
        MiniVisits.add_label()
      end, { desc = 'Add label to current file' })
      
      vim.keymap.set('n', '<Leader>rl', function()
        MiniVisits.remove_label()
      end, { desc = 'Remove label from current file' })
      
      vim.keymap.set('n', '<Leader>fl', function()
        MiniVisits.select_label()
      end, { desc = 'Find files by label' })
      
      -- Navigation through visit history
      vim.keymap.set('n', ']v', function()
        MiniVisits.iterate_paths("forward")
      end, { desc = 'Next visited file' })
      
      vim.keymap.set('n', '[v', function()
        MiniVisits.iterate_paths("backward")
      end, { desc = 'Previous visited file' })
    end
  end
})

return true
