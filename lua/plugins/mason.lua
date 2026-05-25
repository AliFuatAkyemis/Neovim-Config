return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "lua-language-server",
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
                "angular-language-server",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, name in ipairs(opts.ensure_installed or {}) do
                local ok, p = pcall(mr.get_package, name)
                if ok and not p:is_installed() then
                    p:install()
                end
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local mason_path   = vim.fn.stdpath("data") .. "/mason"
            local ng_cmd       = mason_path .. "/bin/ngserver"
            local ng_modules   = mason_path .. "/packages/angular-language-server/node_modules"

            -- Tüm serverlar için capabilities
            vim.lsp.config("*", { capabilities = capabilities })

            -- Server'a özel ayarlar
            vim.lsp.config("vtsls", {
                settings = {
                    javascript = { suggest = { autoImports = true } },
                    typescript = { suggest = { autoImports = true } },
                },
            })

            vim.lsp.config("html", {
                filetypes = { "html", "htmlangular", "javascriptreact", "typescriptreact" },
                get_language_id = function(bufnr, filetype)
                    if filetype == "htmlangular" then
                        return "html"
                    end
                    return filetype
                end,
            })

            vim.lsp.config("angularls", {
                filetypes    = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
                root_markers = { "angular.json", "project.json" },
            })

            vim.lsp.config("tailwindcss", {
                root_dir = function(bufnr, on_dir)
                    local util = require("lspconfig.util")
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    local root_files = {
                        "tailwind.config.js",
                        "tailwind.config.cjs",
                        "tailwind.config.mjs",
                        "tailwind.config.ts",
                        "postcss.config.js",
                        "postcss.config.cjs",
                        "postcss.config.mjs",
                        "postcss.config.ts",
                    }
                    root_files = util.insert_package_json(root_files, "tailwindcss", fname)
                    local match = vim.fs.find(root_files, { path = fname, upward = true })[1]
                    if match then
                        on_dir(vim.fs.dirname(match))
                    end
                end,
            })

            -- Mason-lspconfig: kurulu serverları otomatik enable et
            -- jdtls hariç (jdtls = nvim-jdtls ile ayrıca yönetilir)
            require("mason-lspconfig").setup({
                automatic_enable = {
                    exclude = { "jdtls" },
                },
            })

            -- LSP Keybinds (only when LSP is attached)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            })
        end,
    },
}
