return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ensure_installed = { "lua_ls" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
        local mlsp = require("mason-lspconfig")

        mlsp.setup({
            ensure_installed = { "lua_ls" },
        })

        -- Setup servers using the new native API (Neovim 0.11+)
        vim.lsp.enable("lua_ls")

        -- Keybinds
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end,
    },
}
