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
                "marksman",
                "pyright",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { 
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mlsp = require("mason-lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            mlsp.setup({
                ensure_installed = { "lua_ls", "marksman", "pyright" },
            })

            -- Setup servers
            vim.lsp.config("lua_ls", { capabilities = capabilities })
            vim.lsp.config("marksman", { capabilities = capabilities })
            vim.lsp.config("pyright", { capabilities = capabilities })

            vim.lsp.enable("lua_ls")
            vim.lsp.enable("marksman")
            vim.lsp.enable("pyright")

            -- jdtls is handled separately by nvim-jdtls

            -- Keybinds
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end,
    },
}
