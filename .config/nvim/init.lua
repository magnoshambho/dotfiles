-- This file is the entry point for Neovim

-- Load basic configuration
require("config.options").setup()
require("config.keymaps").setup()

-- Bootstrap and load lazy.nvim
require("config.lazy").setup()
