local M = {}

function M.setup()
  -- Helper function for mapping keys
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
  
  -- Better window navigation
  map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
  
  -- Better indenting
  map("v", "<", "<gv", { desc = "Indent left and reselect" })
  map("v", ">", ">gv", { desc = "Indent right and reselect" })
  
  -- Move lines up and down
  map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
  map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
  map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
  map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
  map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
  
  -- Clear search highlighting with Escape
  map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
  
  -- Save file
  map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
  map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })
  
  -- Quit window
  map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit window" })
  
  -- Open file explorer (we'll set this up with a plugin later)
  map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open file explorer" })
end

return M
