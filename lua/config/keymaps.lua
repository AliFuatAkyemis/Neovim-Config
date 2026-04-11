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
