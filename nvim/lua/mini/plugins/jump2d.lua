-- ~/.config/nvim/lua/mini/plugins/jump2d.lua
-- Configuration for mini.jump2d - Jump to visible text with 2d labels

local loader = require('mini.loader')

loader.load_later('jump2d', function()
  return require('mini.jump2d').setup({
    -- Function producing jump spots (byte indexed) for a particular line
    -- For more information see |MiniJump2d.start|
    spotter = nil, -- Use default spotter
    
    -- Characters used for labels of jump spots (in supplied order)
    labels = 'abcdefghijklmnopqrstuvwxyz',
    
    -- Options for visual effects
    view = {
      -- Whether to dim lines with at least one jump spot
      dim = false,
      
      -- How many steps ahead to show (0 = only current step)
      -- Set to a higher number to show multiple steps ahead
      n_steps_ahead = 1,
    },
    
    -- Which lines are used for computing spots
    allowed_lines = {
      blank = true,       -- Blank line
      cursor_before = true, -- Lines before cursor line
      cursor_at = true,     -- Cursor line
      cursor_after = true,  -- Lines after cursor line
      fold = true,          -- Start of fold
    },
    
    -- Which windows from current tabpage are used for visible lines
    allowed_windows = {
      current = true,
      not_current = true,
    },
    
    -- Functions to be executed at certain events
    hooks = {
      before_start = nil, -- Before jump start
      after_jump = nil,   -- After jump was actually done
    },
    
    -- Module mappings. Use '' (empty string) to disable one.
    mappings = {
      start_jumping = '<CR>',
    },
    
    -- Whether to disable showing non-error feedback
    silent = false,
  })
end)

-- Create mappings to start jump2d for different spotters
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if _G.MiniJump2d then
      -- Basic jumps
      vim.keymap.set({'n', 'x', 'o'}, 's', function()
        MiniJump2d.start()
      end, { desc = 'Jump2d (smart)' })
      
      -- Jump to word start
      vim.keymap.set({'n', 'x', 'o'}, 'S', function()
        MiniJump2d.start(MiniJump2d.builtin_opts.word_start)
      end, { desc = 'Jump2d (word start)' })
      
      -- Jump to line start
      vim.keymap.set({'n', 'x', 'o'}, '<Leader>j', function()
        MiniJump2d.start(MiniJump2d.builtin_opts.line_start)
      end, { desc = 'Jump2d (line start)' })
      
      -- Jump to specific character
      vim.keymap.set({'n', 'x', 'o'}, '<Leader>js', function()
        MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
      end, { desc = 'Jump2d (character)' })
      
      -- Jump to query (customizable search)
      vim.keymap.set({'n', 'x', 'o'}, '<Leader>jq', function()
        MiniJump2d.start(MiniJump2d.builtin_opts.query)
      end, { desc = 'Jump2d (query)' })
    end
  end
})

-- Customize highlight for jump spots
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Make spots very visible against any background
    vim.api.nvim_set_hl(0, 'MiniJump2dSpot', {
      fg = '#ffffff',
      bg = '#000000',
      bold = true,
    })
    
    -- Make unique spots standout even more
    vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', {
      fg = '#ffffff',
      bg = '#7700ff',
      bold = true,
    })
    
    -- Make ahead spots visible but less prominent
    vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', {
      fg = '#aaaaaa',
      bg = '#333333',
    })
  end
})

-- Apply highlight immediately
vim.api.nvim_exec_autocmds('ColorScheme', { pattern = '*' })

return true
