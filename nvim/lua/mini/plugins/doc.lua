-- ~/.config/nvim/lua/mini/plugins/doc.lua
-- Configuration for mini.doc - Generate Neovim help files from annotations

local loader = require('mini.loader')

loader.load_later('doc', function()
  return require('mini.doc').setup({
    -- Function which extracts part of line used to denote annotation
    -- Using EmmyLua-like annotations: "---@tag ..."
    annotation_extractor = function(line)
      -- Match annotation pattern "---@tag" or just "---"
      return string.find(line, '^%-%-%-(@?%S*) ?')
    end,
    
    -- Identifier of block annotation lines until first captured identifier
    default_section_id = '@text',
    
    -- Hooks to be applied at certain stage of document life cycle
    hooks = {
      -- Keep default hooks for most things
      block_pre = nil,
      section_pre = nil,
      sections = {
        -- Custom hook to better format @param sections
        ['@param'] = function(section)
          -- Make param name bold
          local first_line = section[1] or ''
          if first_line:find('{[^}]+}') then return end
          
          local name, desc = first_line:match('^(%S+)%s*(.*)')
          if name then
            section[1] = '{' .. name .. '} ' .. desc
          end
        end,
      },
      section_post = nil,
      block_post = nil,
      file = nil,
      doc = nil,
      write_pre = nil,
      write_post = nil,
    },
    
    -- Path to script which handles project specific help file generation
    script_path = 'scripts/minidoc.lua',
    
    -- Whether to disable showing non-error feedback
    silent = false,
  })
end)

-- Add commands for documentation generation
vim.api.nvim_create_user_command('GenerateDocs', function(cmd_args)
  local input_files = {}
  local output_file = nil
  
  -- Parse command arguments
  if #cmd_args.fargs >= 1 then
    output_file = cmd_args.fargs[1]
  end
  
  if #cmd_args.fargs >= 2 then
    -- Rest of arguments are input files
    for i = 2, #cmd_args.fargs do
      table.insert(input_files, cmd_args.fargs[i])
    end
  end
  
  -- Generate documentation
  require('mini.doc').generate(input_files, output_file)
  
  vim.notify('Documentation generated' .. (output_file and (' to ' .. output_file) or ''), vim.log.levels.INFO)
end, {
  nargs = '*',
  desc = 'Generate documentation using mini.doc',
  complete = 'file'
})

-- Create keymapping for quick doc generation in lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.keymap.set('n', '<Leader>md', function()
      -- Auto-detect output file based on current file/directory
      local current_file = vim.fn.expand('%:p')
      local current_dir = vim.fn.fnamemodify(current_file, ':h')
      local project_dir
      
      -- Try to find project root
      local root_markers = { '.git', 'init.lua', 'lua' }
      for _, marker in ipairs(root_markers) do
        local marker_dir = vim.fn.finddir(marker, current_dir .. ';')
        if marker_dir ~= '' then
          project_dir = vim.fn.fnamemodify(marker_dir, ':p:h:h')
          break
        end
      end
      
      -- Default to current directory if no project root found
      project_dir = project_dir or current_dir
      
      -- Create doc directory if it doesn't exist
      local doc_dir = project_dir .. '/doc'
      vim.fn.mkdir(doc_dir, 'p')
      
      -- Generate output filename based on project name
      local project_name = vim.fn.fnamemodify(project_dir, ':t')
      local output_file = doc_dir .. '/' .. project_name .. '.txt'
      
      -- Generate documentation
      require('mini.doc').generate(nil, output_file)
      
      vim.notify('Documentation generated to ' .. output_file, vim.log.levels.INFO)
    end, { desc = 'Generate documentation', buffer = true })
  end
})

return true
