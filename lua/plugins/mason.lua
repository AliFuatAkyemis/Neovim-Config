return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ensure_installed = { 
                "lua_ls",
                "jdtls",
                "java-debug-adapter",
                "java-test",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { 
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local mlsp = require("mason-lspconfig")

            mlsp.setup({
                ensure_installed = { "lua_ls" },
            })

            -- Setup servers
            vim.lsp.enable("lua_ls")
            -- jdtls is handled separately by nvim-jdtls, so we don't call enable here typically
            -- but we can if we want a basic setup. However, the user has nvim-jdtls.

        -- Keybinds
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end,
    },
}
