local M = {}

function M.setup()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  
  -- Set up lazy.nvim with our configuration
  require("lazy").setup({
    spec = {
      -- import plugins from lua/plugins/
      { import = "plugins" },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },  -- Check for plugin updates
    performance = {
      rtp = {
        -- Disable some built-in plugins we don't need
        disabled_plugins = {
          "gzip",
          "tarPlugin",
          "zipPlugin",
          "tohtml",
          "tutor",
        },
      },
    },
  })
end

return M
