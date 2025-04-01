-- ~/.config/nvim/lua/mini/plugins/notify.lua
-- Configuration for mini.notify

local loader = require('mini.loader')

loader.load_now('notify', function()
  local not_lua_diagnosing = function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end
  local filter_lua_diagnostics = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(not_lua_diagnosing, notif_arr))
  end
  
  local setup = require('mini.notify').setup({
    content = {
      min_severity_level = 'INFO',
      sort = filter_lua_diagnostics
    },
    window = {
      config = { border = 'double' },
      position = 'top',
      width = 60,
      max_width_share = 0.5,
      align = 'left',
      padding = { left = 1, right = 1 },
    },
    default_timeout = 3000,
  })
  
  -- Make the notification system global
  vim.notify = MiniNotify.make_notify()
  
  return setup
end)

return true
