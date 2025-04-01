-- ~/.config/nvim/lua/mini/init.lua
-- Main entry point for all mini.nvim plugins

-- Load the mini plugin loader
local loader = require('mini.loader')

-- =============================================
-- IMMEDIATE LOADING PLUGINS (UI and Core)
-- =============================================

-- Core UI components
require('mini.plugins.basics')    -- Basic settings and options
require('mini.plugins.statusline') -- Status line configuration
require('mini.plugins.tabline')   -- Tab line for buffers and tabs
require('mini.plugins.starter')   -- Start screen
require('mini.plugins.notify')    -- Notification system
require('mini.plugins.icons')     -- Icons for various UI elements

-- =============================================
-- DEFERRED LOADING PLUGINS (Features)
-- =============================================

-- Group: Core Extensions
require('mini.plugins.extra')     -- Extra functionality

-- Group: Text Editing
require('mini.plugins.comment')   -- Comment operations
require('mini.plugins.pairs')     -- Auto-pairing brackets
require('mini.plugins.surround')  -- Surround operations
require('mini.plugins.ai')        -- Text objects
require('mini.plugins.align')     -- Text alignment
require('mini.plugins.operators') -- Text operators

-- Group: Visual Enhancements
require('mini.plugins.indentscope') -- Visual indent scope
require('mini.plugins.hipatterns')  -- Highlight patterns
require('mini.plugins.trailspace')  -- Trailing space highlighting
require('mini.plugins.animate')     -- Animations

-- Group: File and Buffer Navigation
require('mini.plugins.files')      -- File explorer
require('mini.plugins.map')        -- Minimap for navigation
require('mini.plugins.bracketed')  -- Bracketed navigation

-- Group: Code Editing
require('mini.plugins.move')       -- Move lines and selections
require('mini.plugins.splitjoin')  -- Split/join constructs
require('mini.plugins.completion') -- Completion engine

-- Group: UI Enhancements
require('mini.plugins.clue')       -- Key mapping hints/cheatsheet
require('mini.plugins.fuzzy')      -- Fuzzy matching
require('mini.plugins.pick')       -- Picker interface

-- =============================================
-- GROUP 1: Advanced Editing
-- =============================================
require('mini.plugins.snippets')   -- Snippet engine and management
require('mini.plugins.cursorword') -- Highlight word under cursor

-- =============================================
-- GROUP 2: Session and Buffer Management
-- =============================================
require('mini.plugins.sessions')   -- Session management
require('mini.plugins.bufremove')  -- Buffer removal with layout preservation
require('mini.plugins.visits')     -- Track and revisit files

-- =============================================
-- GROUP 3: Git Integration
-- =============================================
require('mini.plugins.git')        -- Git commands and integrations
require('mini.plugins.diff')       -- Visualize and work with diffs

-- =============================================
-- GROUP 4: Enhanced Navigation
-- =============================================
require('mini.plugins.jump')       -- Multi-line f/F/t/T jumps
require('mini.plugins.jump2d')     -- 2D jumping with labels

-- =============================================
-- GROUP 5: Utilities and Documentation
-- =============================================
require('mini.plugins.misc')       -- Miscellaneous utilities
require('mini.plugins.doc')        -- Documentation generation

-- Initialize all plugins
loader.init()

-- Return true to indicate successful loading
return true
