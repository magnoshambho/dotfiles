-- ~/.config/nvim/lua/mini/plugins/sessions.lua
-- Configuration for mini.sessions - Session management

local loader = require('mini.loader')

loader.load_later('sessions', function()
  -- Create custom directory for sessions
  local sessions_dir = vim.fn.stdpath('data') .. '/sessions'
  vim.fn.mkdir(sessions_dir, 'p')
  
  return require('mini.sessions').setup({
    -- Whether to read default session when Neovim opened without file arguments
    autoread = false,
    
    -- Whether to write currently read session before quitting Neovim
    autowrite = true,
    
    -- Directory where sessions are stored
    directory = sessions_dir,
    
    -- File for local session (use '' to disable)
    file = 'Session.vim',
    
    -- Whether to force possibly harmful actions (like overwriting existing session)
    force = { read = false, write = true, delete = false },
    
    -- Hook functions for actions
    hooks = {
      -- Actions before successful operation
      pre = { 
        read = function(session_data)
          vim.notify('Loading session: ' .. session_data.name, vim.log.levels.INFO)
        end,
        write = nil,
        delete = nil
      },
      
      -- Actions after successful operation
      post = {
        read = nil,
        write = function(session_data)
          vim.notify('Session saved: ' .. session_data.name, vim.log.levels.INFO)
        end,
        delete = nil
      },
    },
    
    -- Whether to print session path after action
    verbose = { read = true, write = true, delete = true },
  })
end)

-- Add keymappings for sessions
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only add these when MiniSessions is available
    if _G.MiniSessions then
      vim.keymap.set('n', '<Leader>ss', '<cmd>lua MiniSessions.select()<cr>', { desc = 'Select session' })
      vim.keymap.set('n', '<Leader>sw', '<cmd>lua MiniSessions.write()<cr>', { desc = 'Write session' })
      vim.keymap.set('n', '<Leader>sd', '<cmd>lua MiniSessions.delete()<cr>', { desc = 'Delete session' })
    end
  end
})

return true
