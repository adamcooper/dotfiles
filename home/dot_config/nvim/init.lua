vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps,   { desc = "Keymaps" })
    end,
  },
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { silent = true })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { silent = true })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { silent = true })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})
