-- ~/.config/nvim/lua/mini/plugins/files.lua
-- Configuration for mini.files

local loader = require('mini.loader')

loader.load_later('files', function()
  local files = require('mini.files')
  
  -- Override the default window mapping function to handle ESC specially
  local function custom_window_mappings()
    -- A more reliable way to close on ESC
    vim.keymap.set('n', '<ESC>', function()
      files.close()
    end, { buffer = true, nowait = true })
    
    -- Map to go in with l and <CR>
    vim.keymap.set('n', 'l', function()
      local curdir = files.get_current_item().path
      if vim.fn.isdirectory(curdir) == 1 then
        files.go_in()
      else
        files.go_in()  -- This will open the file
      end
    end, { buffer = true })
    
    vim.keymap.set('n', '<CR>', function()
      local curdir = files.get_current_item().path
      if vim.fn.isdirectory(curdir) == 1 then
        files.go_in()
      else
        files.go_in()  -- This will open the file
      end
    end, { buffer = true })
    
    -- Map to go out with h
    vim.keymap.set('n', 'h', function()
      files.go_out()
    end, { buffer = true })
  end
  
  -- Setup instance with special exit handling
  local setup_result = files.setup({
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 40,
    },
    options = {
      use_as_default_explorer = true,
    },
  })
  
  -- Define a wrapper function that sets up ESC mapping
  local open_with_esc_support = function(...)
    local buf_id = files.open(...)
    
    -- Apply custom window mappings
    if buf_id then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf_id) then
          custom_window_mappings()
        end
      end)
    end
    
    return buf_id
  end
  
  -- Make the enhanced open function available globally
  _G.MiniFilesOpenWithEscSupport = open_with_esc_support
  
  -- Create autocommand to ensure mappings are set whenever mini.files buffer is created
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "minifiles",
    callback = function()
      custom_window_mappings()
    end
  })
  
  return setup_result
end)

return true
