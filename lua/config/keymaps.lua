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

-- Sistem Clipboard
-- y/p  → yalnızca Neovim'in iç register'ı (sistem clipboard'una dokunmaz)
-- "+y  → sistem clipboard'una kopyala (normal: mevcut satır, visual: seçili alan)
-- "+p  → sistem clipboard'undan yapıştır
vim.keymap.set('n', '<leader>y', '"+yy', { desc = "Sistem clipboard'una satırı kopyala" })
vim.keymap.set('v', '<leader>y', '"+y',  { desc = "Sistem clipboard'una seçimi kopyala" })
vim.keymap.set('n', '<leader>p', '"+p',  { desc = "Sistem clipboard'undan yapıştır (sonra)" })
vim.keymap.set('n', '<leader>P', '"+P',  { desc = "Sistem clipboard'undan yapıştır (önce)" })
-- jk -> ESC mapping kaldırıldı: insert modunda "j" yazarken timeoutlen
-- kadar gecikmeye (Neovim jk sequence bekler) neden oluyordu.
-- ESC veya <C-[> kullanın.

-- Buffers
-- Neo-tree penceresindeyken L/H tuşları sidebar'ı bozmasın diye filetype kontrolü yapılıyor
local function buf_nav(cmd)
  return function()
    if vim.bo.filetype == "neo-tree" then return end
    vim.cmd(cmd)
  end
end
vim.keymap.set('n', 'L', buf_nav("bnext"),     { desc = "Next buffer" })
vim.keymap.set('n', 'H', buf_nav("bprevious"), { desc = "Previous buffer" })
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
end

-- Terminal benzeri Copy/Paste kısayolları
-- Alacritty 0.13+ Kitty Keyboard Protocol sayesinde terminal Neovim'de de çalışır.
vim.keymap.set('n', '<C-S-v>', '"+P',        { desc = "Paste from clipboard" })
vim.keymap.set('v', '<C-S-v>', '"+P',        { desc = "Paste from clipboard" })
vim.keymap.set('c', '<C-S-v>', '<C-R>+',     { desc = "Paste from clipboard" })
vim.keymap.set('i', '<C-S-v>', '<C-R><C-O>+',{ desc = "Paste from clipboard" })
vim.keymap.set('v', '<C-S-c>', '"+y',        { desc = "Copy to clipboard" })
