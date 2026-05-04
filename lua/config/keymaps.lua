local builtin = require("telescope.builtin")

-- Telescope
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })

-- Neo-tree
vim.keymap.set('n', '<C-n>', ":Neotree filesystem reveal left<CR>", { desc = "Toggle Neo-tree" })

-- Diagnostics
vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float, { desc = "Open floating diagnostic" })

-- General
vim.keymap.set('n', '<leader>w', ":w<CR>", { desc = "Save file" })
vim.keymap.set('i', 'jk', "<ESC>", { desc = "Escape to Normal mode" })

-- Buffers
vim.keymap.set('n', 'L', ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set('n', 'H', ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set('n', '<leader>x', ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set('n', '<leader>bp', ":BufferLineTogglePin<CR>", { desc = "Toggle pin buffer" })

-- Fix Ctrl+Backspace to delete word by word
vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-H>', '<C-W>', { noremap = true, silent = true })
-- Some terminals send <C-BS> instead of <C-H>
vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-BS>', '<C-W>', { noremap = true, silent = true })
