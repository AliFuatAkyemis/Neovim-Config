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

-- Toggle LSP progress
vim.keymap.set('n', '<leader>up', function()
  if vim.g.lsp_progress_show == false then
    vim.g.lsp_progress_show = true
    vim.notify("LSP Progress Gösteriliyor", vim.log.levels.INFO)
  else
    vim.g.lsp_progress_show = false
    vim.notify("LSP Progress Gizlendi", vim.log.levels.INFO)
  end
end, { desc = "Toggle LSP progress" })

-- Fix Ctrl+Backspace to delete word by word
vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-H>', '<C-W>', { noremap = true, silent = true })
-- Some terminals send <C-BS> instead of <C-H>
vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-BS>', '<C-W>', { noremap = true, silent = true })

-- Fix Ctrl+Delete to delete next word
vim.keymap.set('i', '<C-Del>', '<C-o>dw', { noremap = true, silent = true })
vim.keymap.set('c', '<C-Del>', '<C-Right><C-W>', { noremap = true, silent = true })

-- Neovide specific keymaps
if vim.g.neovide then
    vim.keymap.set('n', '<F11>', function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, { desc = "Toggle Fullscreen" })

    vim.keymap.set({'n', 'v', 'i'}, '<C-S-n>', function()
        vim.fn.jobstart({"alacritty", "--working-directory", vim.fn.getcwd()}, { detach = true })
    end, { desc = "Open Alacritty in current directory" })

    -- Terminal benzeri Copy/Paste kısayolları
    vim.keymap.set('n', '<C-S-v>', '"+P', { desc = "Paste from clipboard" })
    vim.keymap.set('v', '<C-S-v>', '"+P', { desc = "Paste from clipboard" })
    vim.keymap.set('c', '<C-S-v>', '<C-R>+', { desc = "Paste from clipboard" })
    vim.keymap.set('i', '<C-S-v>', '<C-R><C-O>+', { desc = "Paste from clipboard" })
    
    vim.keymap.set('i', '<C-v>', '<C-R><C-O>+', { desc = "Paste from clipboard" })
    vim.keymap.set('c', '<C-v>', '<C-R>+', { desc = "Paste from clipboard" })

    vim.keymap.set('v', '<C-S-c>', '"+y', { desc = "Copy to clipboard" })
end
