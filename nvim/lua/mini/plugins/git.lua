-- ~/.config/nvim/lua/mini/plugins/git.lua
-- Configuration for mini.git - Git integration

local loader = require('mini.loader')

loader.load_later('git', function()
  local setup = require('mini.git').setup({
    -- General CLI execution
    job = {
      -- Path to Git executable
      git_executable = 'git',
      
      -- Timeout (in ms) for each job before force quit
      timeout = 30000,
    },
    
    -- Options for `:Git` command
    command = {
      -- Default split direction
      split = 'auto',
    },
  })
  
  -- Add statusline integration
  -- This shows git information in the statusline if MiniGit is available
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitUpdated",
    callback = function(data)
      -- Customize the summary string format if needed
      -- Default format is fine for most usages
    end
  })
  
  return setup
end)

-- Add Git related keymappings
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only add these when MiniGit is available
    if _G.MiniGit then
      -- Git status
      vim.keymap.set('n', '<Leader>gs', '<cmd>Git status<cr>', 
        { desc = 'Git status' })
      
      -- Git log for current file
      vim.keymap.set('n', '<Leader>gl', '<cmd>Git log --oneline -- %<cr>', 
        { desc = 'Git log (current file)' })
      
      -- Git log for whole repo
      vim.keymap.set('n', '<Leader>gL', '<cmd>Git log --oneline<cr>', 
        { desc = 'Git log (repo)' })
      
      -- Git blame
      vim.keymap.set('n', '<Leader>gb', '<cmd>Git blame<cr>', 
        { desc = 'Git blame' })
      
      -- Git commit
      vim.keymap.set('n', '<Leader>gc', '<cmd>Git commit<cr>', 
        { desc = 'Git commit' })
      
      -- Git diff
      vim.keymap.set('n', '<Leader>gd', '<cmd>Git diff<cr>', 
        { desc = 'Git diff' })
      
      -- Git diff staged
      vim.keymap.set('n', '<Leader>gD', '<cmd>Git diff --staged<cr>', 
        { desc = 'Git diff staged' })
      
      -- Git show at cursor
      vim.keymap.set({'n', 'x'}, '<Leader>gS', function()
        MiniGit.show_at_cursor()
      end, { desc = 'Git show at cursor' })
      
      -- Show range history
      vim.keymap.set({'n', 'x'}, '<Leader>gh', function()
        MiniGit.show_range_history()
      end, { desc = 'Git range history' })
    end
  end
})

return true
