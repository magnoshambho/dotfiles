-- Core plugins that will be used throughout the system
return {
  -- Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- Load this first
    config = function()
      vim.cmd.colorscheme "tokyonight-moon"
    end,
  },
  
  -- File explorer and fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Telescope requires this
    },
    cmd = "Telescope", -- Lazy load on command
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find text" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
    },
    opts = {
      -- Your custom Telescope configuration
    },
  },
  
  -- Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" }, -- Load when buffer is read
    opts = {
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      ensure_installed = {
        "lua",
        "python", -- Since you use Python
        "bash",
        "markdown",
        "json",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
  },
  
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { 
      { "<leader>cm", "<cmd>Mason<CR>", desc = "Open Mason" } 
    },
    opts = {
      -- Let Mason initialize before trying to install packages
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- Remove the automatic installation for now until Mason is working
    end,
  },
}
