-- ~/.config/nvim/init.lua
-- Main Neovim configuration file

-- Bootstrap 'mini.nvim' manually
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' immediately to have its helpers
require('mini.deps').setup()

-- Define main config table to be able to use it in scripts
_G.MiniDeps = require('mini.deps')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Make these functions globally available for plugin config files
_G.add = add
_G.now = now
_G.later = later

-- Start timer to measure startup time
if not vim.g.start_time then
  vim.g.start_time = vim.fn.reltime()
  vim.api.nvim_create_autocmd("UIEnter", {
    callback = function() vim.g.startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time)) * 1000 end,
    once = true
  })
end

-- Load basic settings
require('core.options')

-- Make 'mini.nvim' part of the 'mini-deps-snap'
-- Use 'HEAD' to keep up with latest changes
add({ name = 'mini.nvim', checkout = 'HEAD' })

-- Load external plugins first (for LSP etc)
require('plugins')

-- Load mini.nvim plugins through the new modular structure
require('mini')

-- Load keymaps last, so they can reference plugins
require('core.keymaps')

require('core.mapping')  -- Load the mapping system with FindKeymap command

-- Final configurations to run after all plugins are loaded
later(function()
  -- Any code that should run after all plugins are configured
  vim.cmd('echo "Neovim initialized successfully!"')
end)
