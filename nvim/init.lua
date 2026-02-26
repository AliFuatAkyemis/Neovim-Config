vim.cmd("set expandtab")
vim.cmd("set tabstop=8")
vim.cmd("set softtabstop=8")
vim.cmd("set shiftwidth=8")
vim.g.mapleader = " "

-- Load the plugin manager
require("config.lazy")

-- Custom Keybinds
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ":Neotree filesystem reveal left<CR>")
vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float, { desc = 'Open diagnostic' })
