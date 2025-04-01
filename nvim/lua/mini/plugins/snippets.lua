-- ~/.config/nvim/lua/mini/plugins/snippets.lua
-- Configuration for mini.snippets - Manage and expand snippets

local loader = require('mini.loader')

loader.load_later('snippets', function()
  local gen_loader = require('mini.snippets').gen_loader
  return require('mini.snippets').setup({
    -- Define snippet collection
    snippets = {
      -- Load snippets from standard locations in runtimepath
      gen_loader.from_runtime('lua.json'),
      gen_loader.from_runtime('python.json'),
      gen_loader.from_runtime('rust.json'),
      
      -- Load global snippets
      gen_loader.from_file(vim.fn.stdpath('config') .. '/snippets/global.json'),
      
      -- Load snippets based on filetype
      gen_loader.from_lang(),
    },
    
    -- Module mappings
    mappings = {
      -- Expand snippet at cursor position
      expand = '<C-j>',
      
      -- Navigate through snippet fields
      jump_next = '<C-l>',
      jump_prev = '<C-h>',
      
      -- Stop snippet session
      stop = '<C-c>'
    },
    
    -- Functions describing snippet expansion
    expand = {
      -- Use default expansion behavior
      prepare = nil,
      match = nil,
      select = nil,
      insert = nil,
    },
  })
end)

-- Create snippets directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath('config') .. '/snippets', 'p')

-- Create an example global snippets file if it doesn't exist
local global_snippets_file = vim.fn.stdpath('config') .. '/snippets/global.json'
if vim.fn.filereadable(global_snippets_file) == 0 then
  local example_content = [[{
  "Basic For Loop": {
    "prefix": "for",
    "body": [
      "for (let ${1:i} = 0; $1 < ${2:array}.length; $1++) {",
      "\t${3:// code}$0",
      "}"
    ],
    "description": "Basic for loop"
  },
  "Console Log": {
    "prefix": "log",
    "body": "console.log($1);$0",
    "description": "Console log statement"
  }
}]]
  local file = io.open(global_snippets_file, "w")
  if file then
    file:write(example_content)
    file:close()
  end
end

return true
