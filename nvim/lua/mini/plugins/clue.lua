-- ~/.config/nvim/lua/mini/plugins/clue.lua
-- Configuration for mini.clue - shows next key clues

local loader = require('mini.loader')

loader.load_later('clue', function()
  local miniclue = require('mini.clue')

  -- Block mappings we want to hide from leader menu
  local function filter_leader_mappings()
    return function(maps)
      local hide_keys = {
        -- Maps to hide by direct key
        ['<Leader>e'] = true,
        ['<Leader>E'] = true,
        ['<Leader>q'] = true,
        ['<Leader>Q'] = true,
        ['<Leader>w'] = true,
        ['<Leader>W'] = true,
        ['<Leader>z'] = true,
      }

      -- Filter out the mappings we want to hide
      local filtered = {}
      for _, map in ipairs(maps) do
        if not hide_keys[map.keys] then
          table.insert(filtered, map)
        end
      end

      return filtered
    end
  end

  return miniclue.setup({
    triggers = {
      -- Leader triggers with filter function
      {
        mode = 'n',
        keys = '<Leader>',
        filter = filter_leader_mappings()
      },
      {
        mode = 'x',
        keys = '<Leader>',
        filter = filter_leader_mappings()
      },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance with descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),

      -- Add missing leader key groups descriptions
      -- Buffer operations
      { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
      { mode = 'n', keys = '<Leader>bd', desc = 'Delete buffer' },
      { mode = 'n', keys = '<Leader>bD', desc = 'Force delete buffer' },
      { mode = 'n', keys = '<Leader>bw', desc = 'Wipeout buffer' },
      { mode = 'n', keys = '<Leader>bW', desc = 'Force wipeout buffer' },

      -- Git operations
      { mode = 'n', keys = '<Leader>g', desc = '+Git' },
      { mode = 'n', keys = '<Leader>gs', desc = 'Git status' },
      { mode = 'n', keys = '<Leader>gl', desc = 'Git log (current file)' },
      { mode = 'n', keys = '<Leader>gL', desc = 'Git log (repo)' },
      { mode = 'n', keys = '<Leader>gb', desc = 'Git blame' },
      { mode = 'n', keys = '<Leader>gc', desc = 'Git commit' },
      { mode = 'n', keys = '<Leader>gd', desc = 'Git diff' },
      { mode = 'n', keys = '<Leader>gD', desc = 'Git diff staged' },
      { mode = 'n', keys = '<Leader>gS', desc = 'Git show at cursor' },
      { mode = 'n', keys = '<Leader>gh', desc = 'Git range history' },

      -- Diff operations
      { mode = 'n', keys = '<Leader>d', desc = '+Diff' },
      { mode = 'n', keys = '<Leader>do', desc = 'Toggle diff overlay' },
      { mode = 'n', keys = '<Leader>dt', desc = 'Toggle diff processing' },
      { mode = 'n', keys = '<Leader>dq', desc = 'Diff to quickfix' },
      { mode = 'n', keys = '<Leader>ds', desc = 'Stage all hunks' },
      { mode = 'n', keys = '<Leader>dh', desc = 'Stage hunk under cursor' },

      -- Jump operations
      { mode = 'n', keys = '<Leader>j', desc = '+Jump' },
      { mode = 'n', keys = '<Leader>js', desc = 'Jump2d (character)' },
      { mode = 'n', keys = '<Leader>jq', desc = 'Jump2d (query)' },

      -- Label operations
      { mode = 'n', keys = '<Leader>a', desc = '+Add' },
      { mode = 'n', keys = '<Leader>al', desc = 'Add label to current file' },
      { mode = 'n', keys = '<Leader>r', desc = '+Remove/Reload' },
      { mode = 'n', keys = '<Leader>rl', desc = 'Remove label from current file' },
      { mode = 'n', keys = '<Leader>rr', desc = 'Reload config' },

      -- File operations
      { mode = 'n', keys = '<Leader>f', desc = '+Find/Files' },
      { mode = 'n', keys = '<Leader>ff', desc = 'Find recent files (frecent)' },
      { mode = 'n', keys = '<Leader>fr', desc = 'Find most recent files' },
      { mode = 'n', keys = '<Leader>fF', desc = 'Find most frequent files' },
      { mode = 'n', keys = '<Leader>fl', desc = 'Find files by label' },
      { mode = 'n', keys = '<Leader>fk', desc = 'Find keymaps' },

      -- LSP operations
      { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<Leader>lr', desc = 'Rename symbol' },
      { mode = 'n', keys = '<Leader>la', desc = 'Code action' },
      { mode = 'n', keys = '<Leader>lf', desc = 'Format document' },

      -- Documentation and misc
      { mode = 'n', keys = '<Leader>m', desc = '+Misc/Minimap' },
      { mode = 'n', keys = '<Leader>md', desc = 'Generate documentation' },
      { mode = 'n', keys = '<Leader>mg', desc = 'Get gutter width' },
      { mode = 'n', keys = '<Leader>mr', desc = 'Resize to textwidth' },
      { mode = 'n', keys = '<Leader>mp', desc = 'Print buffer info' },
      { mode = 'n', keys = '<Leader>mb', desc = 'Run benchmark' },

      -- Sessions
      { mode = 'n', keys = '<Leader>s', desc = '+Search/Sessions' },
      { mode = 'n', keys = '<Leader>ss', desc = 'Select session' },
      { mode = 'n', keys = '<Leader>sw', desc = 'Write session' },
      { mode = 'n', keys = '<Leader>sd', desc = 'Delete session' },

      -- Trailing whitespace (CHANGED from <Leader>w to <Leader>t)
      { mode = 'n', keys = '<Leader>t', desc = '+Trailing space' },
      { mode = 'n', keys = '<Leader>ts', desc = 'Trim trailing whitespace' },
      { mode = 'n', keys = '<Leader>tt', desc = 'Toggle trailing whitespace highlighting' },

      -- Diagnostics
      { mode = 'n', keys = '<Leader>i', desc = '+Issues/Diagnostics' },
      { mode = 'n', keys = '<Leader>id', desc = 'Show diagnostic under cursor' },
      { mode = 'n', keys = '<Leader>il', desc = 'List buffer diagnostics' },
      { mode = 'n', keys = '<Leader>iL', desc = 'List workspace diagnostics' },
      { mode = 'n', keys = '<Leader>it', desc = 'Toggle diagnostic virtual text' },
      { mode = 'n', keys = '<Leader>iu', desc = 'Toggle diagnostic underline' },

      -- Open
      { mode = 'n', keys = '<Leader>o', desc = '+Open' },
      { mode = 'n', keys = '<Leader>om', desc = 'Open start menu' },

      -- Quit (only leaving group descriptor)
      { mode = 'n', keys = '<Leader>qq', desc = 'Quit all' },
    },

    window = {
      config = { border = 'rounded' },
      delay = 200,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  })
end)

return true
