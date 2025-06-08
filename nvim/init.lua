vim.cmd("set expandtab")
vim.cmd("set tabstop=8")
vim.cmd("set softtabstop=8")
vim.cmd("set shiftwidth=8")
vim.g.mapleader = " "

require("config.lazy")

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "java" },
        highlight = { enable = true },
        indent = { enable = true }
})

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ":Neotree filesystem reveal left<CR>")

vim.opt.completefunc = 'v:lua.vim.lsp.omnifunc'
vim.api.nvim_set_keymap('i', '<C-Space>', '<C-X><C-U>', { noremap = true, silent = true })

require('lualine').setup()

require('mason').setup()
