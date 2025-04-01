-- ~/.config/nvim/lua/mini/plugins/pick.lua
-- Configuration for mini.pick - mini.nvim's alternative to Telescope

local loader = require('mini.loader')

loader.load_later('pick', function()
  local pick = require('mini.pick')
  
  -- Create a custom picker for diagnostics
  local diagnostics_picker = function(opts)
    opts = opts or {}
    local target = opts.target or "current" -- "current" or "all"
    
    -- Get diagnostics based on target
    local all_diagnostics = vim.diagnostic.get()
    local diagnostics = {}
    
    if target == "current" then
      -- Get diagnostics for current buffer
      diagnostics = vim.diagnostic.get(0)
    else
      -- Get all diagnostics
      diagnostics = all_diagnostics
    end
    
    -- Format diagnostics for display
    local items = {}
    for _, diagnostic in ipairs(diagnostics) do
      local bufnr = diagnostic.bufnr or 0
      local lnum = diagnostic.lnum or 0
      local col = diagnostic.col or 0
      local severity = diagnostic.severity or vim.diagnostic.severity.INFO
      local severity_name = vim.diagnostic.severity[severity] or "UNKNOWN"
      local message = diagnostic.message or ""
      local filename = vim.api.nvim_buf_get_name(bufnr)
      
      -- Format for display
      local display = string.format(
        "%s:%d:%d [%s] %s",
        vim.fn.fnamemodify(filename, ":t"),
        lnum + 1,
        col + 1,
        severity_name,
        message
      )
      
      table.insert(items, {
        text = display,
        bufnr = bufnr,
        lnum = lnum,
        col = col,
        severity = severity,
        message = message,
        filename = filename
      })
    end
    
    -- Sort by severity (higher severity first)
    table.sort(items, function(a, b)
      return a.severity > b.severity
    end)
    
    -- Configure the picker
    local picker_opts = {
      prompt = 'Diagnostics> ',
      source = {
        items = items,
        name = 'diagnostics',
        show = function(item) return item.text end
      },
      mappings = {
        preview_toggle = '<Tab>',
      },
      -- Custom preview
      preview = {
        update = function(buf_id, item)
          -- Clear buffer
          vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, {})
          
          -- Show full path and detailed diagnostic
          vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, {
            "File: " .. vim.fn.fnamemodify(item.filename, ":p"),
            "Line: " .. (item.lnum + 1) .. ", Column: " .. (item.col + 1),
            "Severity: " .. vim.diagnostic.severity[item.severity],
            "",
            "Message:",
            item.message
          })
          
          -- Syntax highlighting
          vim.api.nvim_buf_set_option(buf_id, 'filetype', 'markdown')
        end
      },
      -- Custom action to jump to the diagnostic
      action = function(item)
        vim.api.nvim_set_current_buf(item.bufnr)
        vim.api.nvim_win_set_cursor(0, {item.lnum + 1, item.col})
        
        -- Also show diagnostic in float
        vim.schedule(function()
          vim.diagnostic.open_float()
        end)
      end,
    }
    
    -- Use mini.pick for the UI
    pick.ui(picker_opts)
  end
  
  -- Add the custom picker to the mini.pick.builtin table
  pick.registry.diagnostic_buffer = function() diagnostics_picker({target = "current"}) end
  pick.registry.diagnostic_all = function() diagnostics_picker({target = "all"}) end
  
  return pick.setup({
    -- General options
    options = {
      -- Use borderless window
      border = 'double',
      
      -- Use floating window
      floating_window = {
        height = 0.8,
        width = 0.8,
      },
      
      -- Make the window interactive
      mappings = {
        close = '<C-c>',
        move_up = '<C-k>',
        move_down = '<C-j>',
        scroll_up = '<C-b>',
        scroll_down = '<C-f>',
        choose = '<CR>',
        choose_in_split = '<C-s>',
        choose_in_tabpage = '<C-t>',
        choose_in_vsplit = '<C-v>',
        toggle_preview = '<Tab>',
      },
      
      -- Always show the preview window
      use_preview = true,
    },
    
    -- Slightly customize the window appearance
    window = {
      config = {
        width = 0.8,
        height = 0.8,
      },
    },
  })
end)

return true
