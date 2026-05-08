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
                "vtsls",
                "html-lsp",
                "css-lsp",
                "json-lsp",
                "eslint-lsp",
                "tailwindcss-language-server",
                "clangd",
                "gopls",
                "rust-analyzer",
                "bash-language-server",
                "dockerfile-language-server",
                "yaml-language-server",
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

            local servers = {
                "lua_ls", "marksman", "pyright", "vtsls", "html", "cssls", 
                "jsonls", "eslint", "tailwindcss", "clangd", "gopls", 
                "rust_analyzer", "bashls", "dockerls", "yamlls"
            }

            mlsp.setup({
                ensure_installed = servers,
            })

            -- Setup servers using the new Neovim 0.10+ API
            for _, server in ipairs(servers) do
                vim.lsp.config(server, { capabilities = capabilities })
                vim.lsp.enable(server)
            end

            -- jdtls is handled separately by nvim-jdtls

            -- Keybinds
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end,
    },
}
