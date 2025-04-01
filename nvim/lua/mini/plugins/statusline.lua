-- ~/.config/nvim/lua/mini/plugins/statusline.lua
-- Configuration for mini.statusline

local loader = require('mini.loader')

loader.load_now('statusline', function()
  -- Define custom progress function
  local get_custom_progress = function()
    if MiniStatusline.is_truncated() then return '' end
    local current_line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
    local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
    local progress_percent = current_line / total_lines
    local char_index = math.floor(progress_percent * #chars) + 1
    if char_index > #chars then char_index = #chars end
    return string.format(' %s %3d%%%%', chars[char_index], math.floor(progress_percent * 100))
  end

  return require('mini.statusline').setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local searchcount = MiniStatusline.section_searchcount({ trunc_width = 75 })
        local progress = get_custom_progress()
        local location = string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.virtcol('.'))
        
        return MiniStatusline.combine_groups({
          { hl = mode_hl,                  strings = { mode } },
          { hl = 'MiniStatuslineDevinfo',  strings = { git, diagnostics } },
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          { hl = '%=',                     strings = { '' } },
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = 'MiniStatuslineDevinfo',  strings = { searchcount } },
          { hl = mode_hl,                  strings = { progress, location } },
        })
      end,
      inactive = function()
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        
        return MiniStatusline.combine_groups({
          { hl = 'MiniStatuslineInactive', strings = { filename } },
          { hl = '%=',                     strings = { '' } },
          { hl = 'MiniStatuslineInactive', strings = { fileinfo } },
        })
      end,
    },
    use_icons = true,
    set_vim_settings = true,
  })
end)

return true
