return {
        { "mason-org/mason.nvim", opts = {} },
        {
                "mason-org/mason-lspconfig.nvim",
                opts = {},
                dependencies = {
                        { 
                                "mason-org/mason.nvim", 
                                opts = {} 
                        },
                        "neovim/nvim-lspconfig",
                },
                config = function()
                        require("mason-lspconfig").setup({
                                ensure_installed = { "lua_ls", "jdtls" }
                        })
                end
        },
        { 
                "neovim/nvim-lspconfig",
                config = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup({})
                        lspconfig.jdtls.setup({})
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
                end
        }
}
