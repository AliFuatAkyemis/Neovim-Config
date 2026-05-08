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
                "prettier",
                "stylua",
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
                lua_ls = {},
                marksman = {},
                pyright = {},
                vtsls = {
                    settings = {
                        javascript = {
                            suggest = {
                                autoImports = true,
                            },
                        },
                        typescript = {
                            suggest = {
                                autoImports = true,
                            },
                        },
                    },
                },
                html = {
                    filetypes = { "html", "javascriptreact", "typescriptreact" },
                },
                cssls = {},
                jsonls = {},
                eslint = {},
                tailwindcss = {},
                clangd = {},
                gopls = {},
                rust_analyzer = {},
                bashls = {},
                dockerls = {},
                yamlls = {},
            }

            mlsp.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            for server, config in pairs(servers) do
                local server_config = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                }, config)

                if vim.lsp.config then
                    vim.lsp.config[server] = server_config
                    vim.lsp.enable(server)
                else
                    require("lspconfig")[server].setup(server_config)
                end
            end

            -- jdtls is handled separately by nvim-jdtls

            -- Keybinds
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end,
    },
}
