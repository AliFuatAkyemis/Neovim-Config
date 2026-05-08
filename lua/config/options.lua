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
vim.opt.clipboard = "unnamedplus"
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

-- Indentation fix for HTML/JSX/TSX
-- Treesitter indent is disabled for these filetypes, so we clear indentexpr
-- to prevent Vim's built-in (broken) HTML indenter from running.
-- equalprg routes the = operator through Prettier, so gg=G / == / visual =
-- all produce the same result as <leader>f.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.indentexpr = ""
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = false

    -- Map filetype -> prettier parser
    local parsers = {
      javascript      = "babel",
      javascriptreact = "babel",
      typescript      = "typescript",
      typescriptreact = "babel-ts",
      html            = "html",
    }
    local parser = parsers[vim.bo.filetype]
    if parser then
      -- = operatörü seçili satırları bu komuta pipe eder
      vim.opt_local.equalprg = "prettier --parser " .. parser
    end
  end,
})
