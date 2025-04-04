-- ~/.config/nvim/lua/core/options.lua
-- Neovim options with error handling

-- Function to safely set options
local function set_option(option, value)
  local status_ok, err = pcall(function()
    vim.opt[option] = value
  end)
  
  if not status_ok then
    -- Option not supported in this Neovim version, log to a file for debugging
    local log_file = vim.fn.stdpath('cache') .. '/nvim_option_errors.log'
    local file = io.open(log_file, "a")
    if file then
      file:write(string.format("Error setting option %s: %s\n", option, err))
      file:close()
    end
  end
end

-- General settings
set_option('mouse', 'a')                 -- Enable mouse support
set_option('clipboard', 'unnamedplus')   -- Use system clipboard
set_option('completeopt', 'menu,menuone,noselect')  -- Completion options
set_option('conceallevel', 0)            -- Don't hide quotes in markdown
set_option('fileencoding', 'utf-8')      -- File encoding
set_option('ignorecase', true)           -- Ignore case in search
set_option('smartcase', true)            -- Override ignorecase if search has uppercase
set_option('smartindent', true)          -- Insert indents automatically
set_option('splitbelow', true)           -- New horizontal splits below
set_option('splitright', true)           -- New vertical splits to the right
set_option('termguicolors', true)        -- True color support
set_option('timeoutlen', 300)            -- Timeout for keybindings
set_option('undofile', true)             -- Persistent undo history
set_option('updatetime', 250)            -- Faster update time
set_option('writebackup', false)         -- Disable backup during write
set_option('expandtab', true)            -- Convert tabs to spaces
set_option('shiftwidth', 2)              -- Number of spaces per indent
set_option('tabstop', 2)                 -- Tabs are 2 spaces
set_option('cursorline', true)           -- Highlight cursor line
set_option('number', true)               -- Line numbers
set_option('relativenumber', true)       -- Relative line numbers
set_option('signcolumn', 'yes')          -- Always show sign column
set_option('scrolloff', 8)               -- Context around cursor
set_option('sidescrolloff', 8)           -- Horizontal context
set_option('laststatus', 3)              -- Global statusline

-- Disable some built-in plugins we don't need
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Fix backwards compatibility with newer options
if vim.fn.has('nvim-0.9') == 1 then
  set_option('splitkeep', 'screen')
end

if vim.fn.has('nvim-0.10') == 1 then
  set_option('smoothscroll', true)
end
