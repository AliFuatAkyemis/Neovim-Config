-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = false

-- Visuals
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Behavior
vim.opt.mouse = "a"
-- clipboard = "unnamedplus" kaldırıldı:
-- y/p yalnızca Neovim'in iç register'ını kullanır, sistem clipboard'una dokunmaz.
-- Sistem clipboard'una kopyalamak için: "+y  (bkz. keymaps.lua)
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.scrolloff = 8

-- Aesthetics
vim.opt.title = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- GUI Visuals
if vim.g.neovide or vim.g.nvui or vim.fn.has("gui_running") == 1 then
    vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
end

-- LSP Progress Visibility
vim.g.lsp_progress_show = false

-- Indentation for HTML/JSX/TSX
-- Treesitter indent is disabled for these filetypes.
-- Custom indentexpr (VSCode onEnterRules mantığı) Enter/o/O'da doğru indent sağlar.
-- equalprg routes the = operator through Prettier, so gg=G / == / visual =
-- all produce the same result as <leader>f.
do
  local indent_mod = require("config.indent")
  _G.WebIndent = indent_mod.get_indent  -- indentexpr string referansı için global olmalı
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.indentexpr  = "v:lua.WebIndent()"
    vim.opt_local.autoindent  = true
    vim.opt_local.smartindent = false
    -- Re-indent tetikleyen karakterler: }, ), ], kapanış tag için >
    vim.opt_local.indentkeys  = "0{,0},0(,0),0[,0],0<,0>,:,!^F,o,O,e"

    -- Map filetype -> prettier parser
    local parsers = {
      javascript      = "babel",
      javascriptreact = "babel",
      typescript      = "typescript",
      typescriptreact = "babel-ts",
      html            = "html",
    }
    local parser = parsers[vim.bo.filetype]
    -- We removed equalprg assignment because prettier outputs errors directly to the buffer 
    -- if there is a syntax error (like unclosed bracket). 
    -- conform.nvim already handles formatting safely.
    -- vim.opt_local.equalprg = "prettier --parser " .. parser .. " --tab-width 4"
  end,
})
