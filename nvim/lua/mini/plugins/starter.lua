-- Edit this file at ~/.config/nvim/lua/mini/plugins/starter.lua
-- Find and replace the Telescope entry with mini.pick

local loader = require('mini.loader')

loader.load_now('starter', function()
  local get_greeting = function()
    local hour = tonumber(os.date('%H'))
    local part_of_day = ({
      [0]  = 'night',  [1]  = 'night',  [2]  = 'night',
      [3]  = 'night',  [4]  = 'morning', [5]  = 'morning',
      [6]  = 'morning', [7]  = 'morning', [8]  = 'morning',
      [9]  = 'morning', [10] = 'morning', [11] = 'morning',
      [12] = 'afternoon', [13] = 'afternoon', [14] = 'afternoon',
      [15] = 'afternoon', [16] = 'afternoon', [17] = 'afternoon',
      [18] = 'evening', [19] = 'evening', [20] = 'evening',
      [21] = 'night',  [22] = 'night',  [23] = 'night',
    })[hour]
    return ('Good %s, welcome to Neovim!'):format(part_of_day)
  end
  
  local add_blank_lines = function(content)
    local blank_line = { { type = 'empty', string = '' } }
    for _ = 1, 3 do table.insert(content, 1, vim.deepcopy(blank_line)) end
    for _ = 1, 3 do table.insert(content, vim.deepcopy(blank_line)) end
    return content
  end
  
  local get_footer = function()
    local plugin_paths = vim.fn.globpath(vim.fn.stdpath('data') .. '/site/pack', '*/start/*', false, true)
    local plugin_count = #plugin_paths
    local startup_time = vim.g.startuptime or 0
    if startup_time == 0 and vim.fn.exists('*reltimefloat') == 1 and vim.fn.exists('*reltime') == 1 then
      startup_time = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time or vim.fn.reltime())) * 1000
    end
    
    if startup_time > 0 then
      return ('Neovim loaded in %.2f ms with %d plugins'):format(startup_time, plugin_count)
    else
      return ('Neovim loaded with %d plugins'):format(plugin_count)
    end
  end

  return require('mini.starter').setup({
    header = get_greeting,
    items = {
      { name = 'Session',       action = 'lua MiniSessions.select()',        section = 'Sessions' },
      { name = 'Last session',  action = 'lua MiniSessions.read("last")',    section = 'Sessions' },
      { name = 'Open file',     action = 'lua MiniFiles.open()',             section = 'Files' },
      -- Replace Telescope with mini.pick or mini.visits
      { name = 'Recent files',  action = 'lua MiniVisits.select_path()',     section = 'Files' },
      { name = 'Search',        action = 'lua MiniPick.builtin.grep_live()', section = 'Files' },
      { name = 'Neovim config', action = 'e $MYVIMRC',                       section = 'Settings' },
      { name = 'Plugins',       action = 'lua MiniPick.builtin.files({cwd = "' .. vim.fn.stdpath('data') .. '/site/pack/deps/opt"})', section = 'Settings' },
      { name = 'Lazy-load all', action = 'lua MiniDeps.now()',               section = 'Settings' },
      { name = 'Check health',  action = 'checkhealth',                      section = 'Settings' },
      { name = 'Quit',          action = 'qall',                             section = 'Sessions' },
    },
    footer = get_footer,
    content_hooks = {
      require('mini.starter').gen_hook.adding_bullet(),
      require('mini.starter').gen_hook.aligning('center', 'center'),
      add_blank_lines,
    },
    query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
    window = { config = { border = 'double' } },
    silent = true,
    autoopen = true,
  })
end)

return true
