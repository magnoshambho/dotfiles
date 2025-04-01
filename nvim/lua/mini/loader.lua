-- ~/.config/nvim/lua/mini/loader.lua
-- Loader system for mini.nvim plugins

local M = {}

-- Tables to store plugin configurations
M.immediate_plugins = {}
M.deferred_plugins = {}

-- Function to load plugin immediately (similar to original 'now')
function M.load_now(name, setup_fn)
  table.insert(M.immediate_plugins, {name = name, setup = setup_fn})
end

-- Function to load plugin later (similar to original 'later')
function M.load_later(name, setup_fn)
  table.insert(M.deferred_plugins, {name = name, setup = setup_fn})
end

-- Initialize all plugins in the correct order
function M.init()
  -- First load immediate plugins
  vim.notify("Loading immediate mini.nvim plugins...", vim.log.levels.INFO)
  for _, plugin in ipairs(M.immediate_plugins) do
    local status, err = pcall(plugin.setup)
    if not status then
      vim.notify("Error loading mini." .. plugin.name .. ": " .. err, vim.log.levels.ERROR)
    end
  end
  
  -- Then load deferred plugins using the global 'later' function
  later(function()
    vim.notify("Loading deferred mini.nvim plugins...", vim.log.levels.INFO)
    for _, plugin in ipairs(M.deferred_plugins) do
      local status, err = pcall(plugin.setup)
      if not status then
        vim.notify("Error loading mini." .. plugin.name .. ": " .. err, vim.log.levels.ERROR)
      end
    end
  end)
end

return M
