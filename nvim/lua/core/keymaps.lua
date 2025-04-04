-- ~/.config/nvim/lua/core/keymaps.lua
-- Key mappings for Neovim

return now(function()
  -- Local utilities
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }
  
  -- Leader already defined as space in options.lua
  
  -- Quick escape from insert mode with jk or kj
  -- These won't show in leader menu notifications
  map('i', 'jk', '<Esc>', opts)
  map('i', 'kj', '<Esc>', opts)
  
  -- Basic mappings
  -- Better navigation on wrapped lines
  map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  
  -- Better indentation in visual mode
  map('v', '<', '<gv', opts)
  map('v', '>', '>gv', opts)
  
  -- Buffer navigation
  map('n', '<Tab>', ':bnext<CR>', opts)
  map('n', '<S-Tab>', ':bprevious<CR>', opts)
  
  -- Window navigation
  map('n', '<C-h>', '<C-w>h', opts)
  map('n', '<C-j>', '<C-w>j', opts)
  map('n', '<C-k>', '<C-w>k', opts)
  map('n', '<C-l>', '<C-w>l', opts)
  
  -- Resize windows
  map('n', '<C-Up>', ':resize -2<CR>', opts)
  map('n', '<C-Down>', ':resize +2<CR>', opts)
  map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
  map('n', '<C-Right>', ':vertical resize +2<CR>', opts)
  
  -- Remove search highlighting
  map('n', '<Esc>', ':noh<CR>', opts)
  
  -- Close buffers (RESTORED)
  map('n', '<Leader>q', ':bd<CR>', { desc = 'Close buffer' })
  map('n', '<Leader>Q', ':bd!<CR>', { desc = 'Force close buffer' })
  
  -- Save file (RESTORED)
  map('n', '<Leader>w', ':w<CR>', { desc = 'Save file' })
  map('n', '<Leader>W', ':wa<CR>', { desc = 'Save all files' })
  
  -- Quit
  map('n', '<Leader>qq', ':qa<CR>', { desc = 'Quit all' })
  
  -- Mappings for better usability
  -- Move lines in visual mode
  map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
  map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
  
  -- Join lines without moving cursor
  map('n', 'J', 'mzJ`z', opts)
  
  -- Find keymaps
  map('n', '<Leader>fk', ":FindKeymap ", { desc = 'Find keymaps' })
  
  -- Update these mappings in your keymaps.lua file

  -- File explorer (mini.files) with ESC support
  -- Use the global wrapper function that includes ESC mapping
  map('n', '<C-e>', function() 
    -- Use the enhanced function with ESC support
    _G.MiniFilesOpenWithEscSupport()
  end, { desc = 'Open file explorer' })

  -- Open with leader key
  map('n', '<Leader>e', function() 
    _G.MiniFilesOpenWithEscSupport()
  end, { desc = 'Open file explorer' })

  -- Open explorer at current file
  map('n', '<Leader>E', function()
    _G.MiniFilesOpenWithEscSupport(vim.api.nvim_buf_get_name(0))
  end, { desc = 'Open explorer at current file' })

  -- Diagnostic mappings (directly available outside defer_fn)
  -- Navigation (also provided by mini.bracketed)
  map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
  map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
  
  -- Diagnostic commands with i prefix (changed from x to avoid conflicts with x command)
  map('n', '<Leader>id', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })
  
  -- Using mini.pick for diagnostics (instead of Telescope)
  map('n', '<Leader>il', function()
    -- Check if mini.pick is available
    if package.loaded['mini.pick'] then
      require('mini.pick').registry.diagnostic_buffer()
    else
      -- Fallback to builtin diagnostics
      vim.diagnostic.setqflist({open = true})
    end
  end, { desc = 'List buffer diagnostics' })
  
  map('n', '<Leader>iL', function()
    -- Check if mini.pick is available
    if package.loaded['mini.pick'] then
      require('mini.pick').registry.diagnostic_all()
    else
      -- Fallback to builtin diagnostics
      vim.diagnostic.setqflist({open = true})
    end
  end, { desc = 'List workspace diagnostics' })
  
  map('n', '<Leader>it', function() 
    vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})
  end, { desc = 'Toggle diagnostic virtual text' })
  
  -- LSP mappings (for immediate availability)
  map('n', 'K', function() 
    vim.lsp.buf.hover() 
  end, { desc = 'Hover documentation' })
  
  map('n', 'gd', function() 
    vim.lsp.buf.definition() 
  end, { desc = 'Go to definition' })
  
  map('n', 'gr', function() 
    vim.lsp.buf.references() 
  end, { desc = 'Go to references' })
  
  map('n', '<Leader>lr', function() 
    vim.lsp.buf.rename() 
  end, { desc = 'Rename symbol' })
  
  map('n', '<Leader>la', function() 
    vim.lsp.buf.code_action() 
  end, { desc = 'Code action' })
  
  map('n', '<Leader>lf', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'Format document' })
  
  -- Use defer_fn to set plugin-specific mappings AFTER all plugins are loaded
  vim.defer_fn(function()
    -- Basic mini plugins
    if package.loaded['mini.starter'] then
      map('n', '<Leader>om', '<Cmd>lua MiniStarter.open()<CR>', { desc = 'Open start menu' })
    end
    
    -- mini.extra (diagnostics) - if available
    if package.loaded['mini.extra'] then
      local mini_extra = require('mini.extra')
      
      -- Use mini.extra's diagnostic functions if available, otherwise use standard vim.diagnostic
      if mini_extra.diagnostic_goto_prev then
        map('n', '[d', mini_extra.diagnostic_goto_prev, { desc = 'Previous diagnostic' })
      end
      
      if mini_extra.diagnostic_goto_next then
        map('n', ']d', mini_extra.diagnostic_goto_next, { desc = 'Next diagnostic' })
      end
      
      -- For diagnostic listings, we'll prefer mini.pick over mini.extra
      if package.loaded['mini.pick'] then
        -- Mini.pick is already mapped above
      elseif mini_extra.pickers and mini_extra.pickers.list_diagnostics then
        map('n', '<Leader>il', function()
          mini_extra.pickers.list_diagnostics({ scope = 'current' })
        end, { desc = 'List buffer diagnostics' })
        
        map('n', '<Leader>iL', function()
          mini_extra.pickers.list_diagnostics({ scope = 'workspace' })
        end, { desc = 'List workspace diagnostics' })
      end
      
      if mini_extra.commands and mini_extra.commands.toggle_diagnostic_display then
        map('n', '<Leader>it', function()
          mini_extra.commands.toggle_diagnostic_display('virtualtext')
        end, { desc = 'Toggle diagnostic virtual text' })
        
        map('n', '<Leader>iu', function()
          mini_extra.commands.toggle_diagnostic_display('underline')
        end, { desc = 'Toggle diagnostic underline' })
      end
    end
    
    -- mini.pick - file and buffer picking
    if package.loaded['mini.pick'] then
      local pick = require('mini.pick')
      map('n', '<Leader>ff', function() pick.builtin.files() end, { desc = 'Find files' })
      map('n', '<Leader>fb', function() pick.builtin.buffers() end, { desc = 'Find buffers' })
      map('n', '<Leader>fg', function() pick.builtin.grep_live() end, { desc = 'Live grep' })
      map('n', '<Leader>fr', function() pick.builtin.resume() end, { desc = 'Resume last picker' })
    end
    
    -- Additional mappings for newly added plugins
    
    -- mini.map - minimap operations
    if package.loaded['mini.map'] then
      -- Used m prefix, but with distinctive second letter to avoid conflicts
      map('n', '<Leader>mp', '<Cmd>lua MiniMap.toggle()<CR>', { desc = 'Toggle minimap' })
      map('n', '<Leader>mf', '<Cmd>lua MiniMap.toggle_focus()<CR>', { desc = 'Toggle minimap focus' })
      map('n', '<Leader>mr', '<Cmd>lua MiniMap.refresh()<CR>', { desc = 'Refresh minimap' })
      map('n', '<Leader>ms', '<Cmd>lua MiniMap.toggle_side()<CR>', { desc = 'Toggle minimap side' })
    end
    
    -- mini.trailspace - trailing whitespace operations
    -- CHANGED: Changed prefix from <Leader>w to <Leader>ts for "trailing space"
    if package.loaded['mini.trailspace'] then
      map('n', '<Leader>ts', '<Cmd>lua MiniTrailspace.trim()<CR>', { desc = 'Trim trailing whitespace' })
      map('n', '<Leader>tt', '<Cmd>lua vim.b.minitrailspace_disable = not vim.b.minitrailspace_disable<CR>', 
          { desc = 'Toggle trailing whitespace highlighting' })
    end
    
    -- mini.align mappings (already has ga operator)
    
    -- mini.bracketed mappings (already has default keybindings)
    if package.loaded['mini.bracketed'] then
      -- These complement the default [f ]f, [b ]b, etc. mappings
      map('n', '[t', '<Cmd>lua MiniBracketed.jump("target", "backward")<CR>', { desc = 'Previous target' })
      map('n', ']t', '<Cmd>lua MiniBracketed.jump("target", "forward")<CR>', { desc = 'Next target' })
    end
    
    -- mini.splitjoin - toggle between single line and multi-line constructs
    if package.loaded['mini.splitjoin'] then
      map('n', 'gS', '<Cmd>lua MiniSplitjoin.toggle()<CR>', { desc = 'Toggle split/join' })
    end
    
    -- Register mappings with whichkey if available
    if package.loaded["which-key"] then
      local wk = require("which-key")
      wk.register({
        ["<leader>"] = {
          l = { name = "LSP" },
          i = { name = "Issues/Diagnostics" }, -- Changed from 'x' to 'i'
          q = { name = "Quit/Close" },
          t = { name = "Trailing space" }, -- CHANGED: was 'w' for Write/Save/Whitespace
          w = { name = "Write/Save" }, -- RESTORED: For save file mappings
          o = { name = "Open" },
          f = { name = "Find" },
          m = { name = "Minimap" },
          e = "Explorer", -- Add description for the explorer key
          E = "Explorer at file", -- Add description for the explorer at file key
        }
      })
    end
    
    -- Update mini.clue config if available
    if package.loaded['mini.clue'] then
      -- Add file explorer clues to mini.clue
      table.insert(MiniClue.config.clues, { mode = 'n', keys = '<Leader>e', desc = 'Open file explorer' })
      table.insert(MiniClue.config.clues, { mode = 'n', keys = '<Leader>E', desc = 'Open explorer at current file' })
      table.insert(MiniClue.config.clues, { mode = 'n', keys = '<C-e>', desc = 'Open file explorer' })
      
      -- Ensure clues are updated
      MiniClue.ensure_all_triggers()
    end
  end, 100) -- Defer for 100ms to ensure plugins are loaded
end)
