local M = {}

function M.setup()
  -- General settings
  vim.g.mapleader = " "  -- Set leader key to space
  vim.g.maplocalleader = "\\"
  
  -- UI settings
  vim.opt.number = true         -- Show line numbers
  vim.opt.relativenumber = true -- Show relative line numbers
  vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
  vim.opt.signcolumn = "yes"    -- Always show the sign column
  
  -- Indentation
  vim.opt.expandtab = true   -- Use spaces instead of tabs
  vim.opt.shiftwidth = 4     -- Size of an indent
  vim.opt.tabstop = 4        -- Number of spaces tabs count for
  vim.opt.softtabstop = 4    -- Number of spaces for a tab
  vim.opt.smartindent = true -- Insert indents automatically
  
  -- Search settings
  vim.opt.ignorecase = true  -- Ignore case in search patterns
  vim.opt.smartcase = true   -- Override ignorecase if search contains uppercase
  
  -- File handling
  vim.opt.undofile = true    -- Persistent undo history
  vim.opt.swapfile = false   -- Don't use swapfiles
  vim.opt.backup = false     -- Don't create backup files
  
  -- System settings
  vim.opt.updatetime = 250   -- Faster update time
  vim.opt.timeoutlen = 300   -- Faster timeout for key combinations
  
  -- Better Python indentation (since you work with Python)
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  vim.g.python_recommended_style = 1
end

return M
