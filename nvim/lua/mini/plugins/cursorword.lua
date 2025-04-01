-- ~/.config/nvim/lua/mini/plugins/cursorword.lua
-- Configuration for mini.cursorword - Autohighlight word under cursor

local loader = require('mini.loader')

loader.load_later('cursorword', function()
  return require('mini.cursorword').setup({
    -- Delay (in ms) between when cursor moved and when highlighting appears
    delay = 100,
  })
end)

-- Add custom highlight for a more subtle and pleasing appearance
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Define highlight based on colorscheme (works with both light and dark themes)
    local cursorword_hl = { underline = true }
    
    -- If current colorscheme has a comment color, use it for cursorword
    -- This ensures it's visible but not distracting
    local comment_hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
    if comment_hl and comment_hl.fg then
      cursorword_hl.sp = string.format('#%06x', comment_hl.fg)
    end
    
    vim.api.nvim_set_hl(0, 'MiniCursorword', cursorword_hl)
  end,
})

-- Trigger highlight update immediately after setup
vim.api.nvim_exec_autocmds('ColorScheme', { pattern = '*' })

return true
