-- Python-specific plugins and configurations
return {
  -- Python formatter with Black
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    ft = { "python" },
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  
  -- Python test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    ft = { "python" },
    keys = {
      { "<leader>tt", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run nearest test" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", desc = "Run current file" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            python = "python",
            runner = "pytest",
          }),
        },
      })
    end,
  },
  
  -- Python debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
    },
    ft = { "python" },
    keys = {
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<CR>", desc = "Continue" },
      { "<leader>do", "<cmd>lua require('dap').step_over()<CR>", desc = "Step over" },
      { "<leader>di", "<cmd>lua require('dap').step_into()<CR>", desc = "Step into" },
    },
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup("python")
      
      require("dapui").setup()
      
      -- Connect DAP UI to DAP events
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
