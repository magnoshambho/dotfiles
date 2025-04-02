-- ~/.config/nvim/lua/mini/plugins/pick.lua
-- Configuration for mini.pick - mini.nvim's alternative to Telescope

local loader = require('mini.loader')

loader.load_later('pick', function()
  local pick = require('mini.pick')
  
  -- Calculate integer values for height and width based on screen size
  local screen_height = vim.o.lines
  local screen_width = vim.o.columns
  local win_height = math.floor(screen_height * 0.8)
  local win_width = math.floor(screen_width * 0.8)
  
  local setup_result = pick.setup({
    -- General options
    options = {
      -- Use borderless window
      border = 'double',
      
      -- Use floating window with concrete values
      floating_window = {
        height = win_height,
        width = win_width,
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
    
    -- Window configuration with concrete values
    window = {
      config = {
        width = win_width,
        height = win_height,
      },
    },
  })
  
  -- After setup, register custom diagnostic pickers
  vim.schedule(function()
    -- Create a diagnostic picker function using the fully loaded pick module
    pick.registry.diagnostic_buffer = function()
      -- Get diagnostics for current buffer
      local diagnostics = vim.diagnostic.get(0)
      
      -- Format diagnostics for display
      local items = {}
      for _, diagnostic in ipairs(diagnostics) do
        local lnum = diagnostic.lnum or 0
        local col = diagnostic.col or 0
        local severity = diagnostic.severity or vim.diagnostic.severity.INFO
        local severity_name = vim.diagnostic.severity[severity] or "UNKNOWN"
        local message = diagnostic.message or ""
        
        -- Format for display
        local display = string.format(
          "%d:%d [%s] %s",
          lnum + 1,
          col + 1,
          severity_name,
          message
        )
        
        table.insert(items, {
          text = display,
          lnum = lnum,
          col = col,
          severity = severity,
          message = message
        })
      end
      
      -- Sort by severity (higher severity first)
      table.sort(items, function(a, b)
        return a.severity > b.severity
      end)
      
      if #items == 0 then
        vim.notify("No diagnostics found in current buffer", vim.log.levels.INFO)
        return
      end
      
      -- Call the picker
      pick.ui({
        prompt = 'Buffer Diagnostics> ',
        source = {
          items = items,
          name = 'buffer_diagnostics',
          show = function(item) return item.text end
        },
        mappings = {
          preview_toggle = '<Tab>',
        },
        -- Jump to the diagnostic location when selected
        action = function(item)
          vim.api.nvim_win_set_cursor(0, {item.lnum + 1, item.col})
          vim.schedule(function()
            vim.diagnostic.open_float()
          end)
        end
      })
    end
    
    -- All diagnostics picker
    pick.registry.diagnostic_all = function()
      -- Get all diagnostics
      local all_diagnostics = vim.diagnostic.get()
      
      -- Format diagnostics for display
      local items = {}
      for _, diagnostic in ipairs(all_diagnostics) do
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
      
      if #items == 0 then
        vim.notify("No diagnostics found", vim.log.levels.INFO)
        return
      end
      
      -- Call the picker
      pick.ui({
        prompt = 'All Diagnostics> ',
        source = {
          items = items,
          name = 'all_diagnostics',
          show = function(item) return item.text end
        },
        mappings = {
          preview_toggle = '<Tab>',
        },
        -- Custom preview showing file and diagnostic details
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
        -- Jump to the diagnostic location when selected
        action = function(item)
          vim.api.nvim_set_current_buf(item.bufnr)
          vim.api.nvim_win_set_cursor(0, {item.lnum + 1, item.col})
          vim.schedule(function()
            vim.diagnostic.open_float()
          end)
        end
      })
    end
  end)
  
  return setup_result
end)

return true
