-- ~/.config/nvim/lua/mini/plugins/clue.lua
-- Configuration for mini.clue - shows available key mappings as you type

local loader = require('mini.loader')

loader.load_later('clue', function()
  return require('mini.clue').setup({
    -- Time (in ms) to wait before showing clues for the first time
    window = {
      delay = 200,
      config = {
        border = 'rounded',
        width = 'auto',
      },
    },

    -- Configure which key groups should show in the clue window
    triggers = {
      -- Leader key shows available leader mappings
      { mode = 'n', keys = '<Leader>' },
      -- Function key mappings
      { mode = 'n', keys = '<F' },
      { mode = 'n', keys = '<C-F' },
      -- g key shows available 'go-to' mappings
      { mode = 'n', keys = 'g' },
      -- z key shows available folding and spell fix mappings
      { mode = 'n', keys = 'z' },
      -- ] and [ show available navigation mappings
      { mode = 'n', keys = ']' },
      { mode = 'n', keys = '[' },
      -- Window navigation/management with <C-w>
      { mode = 'n', keys = '<C-w>' },
    },

    -- Show clues for normal/operator-pending mappings
    clues = {
      -- Enhance built-in help with mini.clue
      -- This shows enhanced F1 help in a floating window
      require('mini.clue').gen_clues.builtin_completion(),
      require('mini.clue').gen_clues.g(),
      require('mini.clue').gen_clues.marks(),
      require('mini.clue').gen_clues.registers(),
      require('mini.clue').gen_clues.windows(),
      require('mini.clue').gen_clues.z(),
    },

    -- Custom clues for common key group prefixes
    clue_patterns = {
      -- Leader mappings clues
      { pattern = '^<Leader>f', group = 'Find' },
      { pattern = '^<Leader>l', group = 'LSP' },
      { pattern = '^<Leader>i', group = 'Issues/Diagnostics' }, -- Changed from x to i
      { pattern = '^<Leader>m', group = 'Minimap' },
      { pattern = '^<Leader>w', group = 'Whitespace/Write' },
      { pattern = '^<Leader>o', group = 'Open' },
      { pattern = '^<Leader>q', group = 'Quit/Buffer' },
      { pattern = '^<Leader>s', group = 'Search/Replace' },
      { pattern = '^<Leader>e', group = 'Explorer' },
      { pattern = '^<Leader>r', group = 'Reload/Replace' },
      
      -- z prefix mappings (including our custom surround mappings)
      { pattern = '^z[adfFhr]', group = 'Surround' },
      { pattern = '^z[op]', group = 'Fold' },
      { pattern = '^z[=g]', group = 'Spelling' },
      
      -- g prefix mappings
      { pattern = '^g[hjkl]', group = 'Motion' },
      { pattern = '^gS', group = 'Split/Join' },
      { pattern = '^g[=mM/z]', group = 'Operators' },
      
      -- Brackets navigation
      { pattern = '^%[', group = 'Previous' },
      { pattern = '^%]', group = 'Next' },
    },
  })
end)

return true
