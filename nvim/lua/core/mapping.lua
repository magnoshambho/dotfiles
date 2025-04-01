-- ~/.config/nvim/lua/core/mapping.lua
-- Reference guide for all automatically created mappings by mini.nvim

-- Only need to update the custom keymap documentation section near the end
-- where we describe our custom diagnostics mappings

-- Function to search for keymaps
local function find_keymap(search_term)
  -- Convert to lowercase for case-insensitive search
  search_term = string.lower(search_term)
  
  -- Results table
  local results = {}
  
  -- Search through mini mappings
  for _, mapping in ipairs(mini_mappings) do
    if string.find(string.lower(mapping.mapping), search_term) or 
       string.find(string.lower(mapping.description), search_term) or
       string.find(string.lower(mapping.plugin), search_term) then
      table.insert(results, mapping)
    end
  end
  
  -- Custom mappings for documentation 
  local custom_mappings = {
    -- Diagnostic mappings
    { plugin = "custom", mode = "n", mapping = "<Leader>id", description = "Show diagnostic under cursor" },
    { plugin = "custom", mode = "n", mapping = "<Leader>il", description = "List buffer diagnostics" },
    { plugin = "custom", mode = "n", mapping = "<Leader>iL", description = "List workspace diagnostics" },
    { plugin = "custom", mode = "n", mapping = "<Leader>it", description = "Toggle diagnostic virtual text" },
    { plugin = "custom", mode = "n", mapping = "<Leader>iu", description = "Toggle diagnostic underline" },
    -- LSP mappings
    { plugin = "custom", mode = "n", mapping = "<Leader>lr", description = "Rename symbol" },
    { plugin = "custom", mode = "n", mapping = "<Leader>la", description = "Code action" },
    { plugin = "custom", mode = "n", mapping = "<Leader>lf", description = "Format document" },
    -- Other useful custom mappings 
    { plugin = "custom", mode = "n", mapping = "<Leader>fk", description = "Find keymaps" },
    { plugin = "custom", mode = "n", mapping = "<Leader>om", description = "Open start menu" },
  }
  
  -- Add custom mappings to results if they match
  for _, mapping in ipairs(custom_mappings) do
    if string.find(string.lower(mapping.mapping), search_term) or 
       string.find(string.lower(mapping.description), search_term) then
      table.insert(results, mapping)
    end
  end
  
  -- Search through currently mapped keys
  local modes = {'n', 'v', 'x', 'i', 'o', 't', 'c'}
  for _, mode in ipairs(modes) do
    for lhs, mapping_table in pairs(vim.api.nvim_get_keymap(mode)) do
      if string.find(string.lower(lhs), search_term) or 
         (mapping_table.rhs and string.find(string.lower(mapping_table.rhs), search_term)) or
         (mapping_table.desc and string.find(string.lower(mapping_table.desc), search_term)) then
        
        -- Only add this if not already in results from mini_mappings or custom_mappings
        local is_duplicate = false
        for _, existing_map in ipairs(results) do
          if existing_map.mode == mode and existing_map.mapping == lhs then
            is_duplicate = true
            break
          end
        end
        
        if not is_duplicate then
          table.insert(results, {
            plugin = "user or vim", 
            mode = mode, 
            mapping = lhs, 
            description = mapping_table.desc or mapping_table.rhs or "Unknown"
          })
        end
      end
    end
  end
  
  return results
end

-- Rest of the file continues as before
