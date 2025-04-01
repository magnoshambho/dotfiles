-- ~/.config/nvim/lua/mini/init.lua
-- Main entry point for all mini.nvim plugins

-- Load the mini plugin loader
local loader = require('mini.loader')

-- Load all immediately plugins (UI and core components)
require('mini.plugins.basics')
require('mini.plugins.statusline')
require('mini.plugins.starter')
require('mini.plugins.notify')
require('mini.plugins.icons')
require('mini.plugins.tabline')

-- Load all deferred plugins (features not needed immediately)
require('mini.plugins.extra')
require('mini.plugins.comment')
require('mini.plugins.pairs')
require('mini.plugins.surround')
require('mini.plugins.ai')
require('mini.plugins.indentscope')
require('mini.plugins.files')
require('mini.plugins.hipatterns')
require('mini.plugins.trailspace')
require('mini.plugins.completion')
require('mini.plugins.align')
require('mini.plugins.animate')
require('mini.plugins.bracketed')
require('mini.plugins.map')
require('mini.plugins.move')
require('mini.plugins.operators')
require('mini.plugins.splitjoin')
require('mini.plugins.clue')

-- New plugins
require('mini.plugins.fuzzy')
require('mini.plugins.pick')

-- Initialize all plugins
loader.init()

-- Return true to indicate successful loading
return true
