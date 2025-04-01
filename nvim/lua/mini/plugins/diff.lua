-- ~/.config/nvim/lua/mini/plugins/diff.lua
-- Configuration for mini.diff - Visualize and work with diff hunks

local loader = require('mini.loader')

loader.load_later('diff', function()
  local setup = require('mini.diff').setup({
    -- Options for how hunks are visualized
    view = {
      -- Visualization style. Possible values are 'sign' and 'number'.
      style = 'sign',
      
      -- Signs used for hunks with 'sign' view
      signs = { add = '▒', change = '▒', delete = '▒' },
      
      -- Priority of used visualization extmarks
      priority = 199,
    },
    
    -- Source for how reference text is computed/updated/etc
    -- Uses content from Git index by default
    source = nil,  -- Use default Git source
    
    -- Delays (in ms) defining asynchronous processes
    delay = {
      -- How much to wait before update following every text change
      text_change = 200,
    },
    
    -- Module mappings
    mappings = {
      -- Apply hunks inside a visual/operator region
      apply = 'gh',
      
      -- Reset hunks inside a visual/operator region
      reset = 'gH',
      
      -- Hunk range textobject
      textobject = 'ih',
      
      -- Go to hunk range in corresponding direction
      goto_first = '[H',
      goto_prev = '[h',
      goto_next = ']h',
      goto_last = ']H',
    },
    
    -- Various options
    options = {
      -- Diff algorithm
      algorithm = 'histogram',
      
      -- Whether to use "indent heuristic"
      indent_heuristic = true,
      
      -- The amount of second-stage diff to align lines
      linematch = 60,
      
      -- Whether to wrap around edges during hunk navigation
      wrap_goto = false,
    },
  })
  
  -- Set up diff fold expression for git and diff filetypes
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'git', 'diff' },
    callback = function()
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'v:lua.MiniDiff.diff_foldexpr()'
    end
  })
  
  -- Integrate with statusline if possible
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniDiffUpdated",
    callback = function(data)
      -- Customize the summary string format if needed
      -- Default format is fine for most usages
    end
  })
  
  return setup
end)

-- Add additional keymappings for diff operations
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only add these when MiniDiff is available
    if _G.MiniDiff then
      -- Toggle diff overlay
      vim.keymap.set('n', '<Leader>do', function()
        MiniDiff.toggle_overlay()
      end, { desc = 'Toggle diff overlay' })
      
      -- Toggle diff processing
      vim.keymap.set('n', '<Leader>dt', function()
        MiniDiff.toggle()
      end, { desc = 'Toggle diff processing' })
      
      -- Export hunks to quickfix list
      vim.keymap.set('n', '<Leader>dq', function()
        vim.fn.setqflist(MiniDiff.export('qf'))
        vim.cmd('copen')
      end, { desc = 'Diff to quickfix' })
      
      -- Stage/unstage operations
      vim.keymap.set('n', '<Leader>ds', function()
        -- Apply all hunks in current buffer
        local hunks = MiniDiff.get_buf_data().hunks
        MiniDiff.do_hunks(0, 'apply')
      end, { desc = 'Stage all hunks' })
      
      -- Stage/unstage operations for single hunk
      vim.keymap.set('n', '<Leader>dh', function()
        -- Apply hunk under cursor
        MiniDiff.do_hunks(0, 'apply', {
          line_start = vim.fn.line('.'),
          line_end = vim.fn.line('.')
        })
      end, { desc = 'Stage hunk under cursor' })
    end
  end
})

return true
