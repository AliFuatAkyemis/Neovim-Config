return {
        {
                "nvim-treesitter/nvim-treesitter",
                branch = 'main',
                lazy = false,
                build = ":TSUpdate",
                config = function()
                        local ts = require("nvim-treesitter")
                        ts.setup({})

                        local ensure_installed = {
                                "c", "lua", "vim", "vimdoc", "query", "python",
                                "javascript", "typescript", "tsx", "html", "css",
                                "json", "yaml", "bash", "dockerfile", "go", "rust", "cpp",
                                "markdown", "markdown_inline", "angular", "kotlin"
                        }

                        -- Install parsers asynchronously
                        ts.install(ensure_installed)

                        vim.treesitter.language.register("angular", "htmlangular")

                        -- Enable features (like highlighting, indent) using native Neovim APIs
                        vim.api.nvim_create_autocmd("FileType", {
                                pattern = ensure_installed,
                                callback = function(ev)
                                        local ft = ev.match
                                        
                                        -- Enable Treesitter highlighting
                                        pcall(vim.treesitter.start, ev.buf, ft)

                                        -- Enable Treesitter indentation (disable for web frontends as requested in original config)
                                        local disable_indent = { "html", "htmlangular", "angular", "javascript", "typescript", "tsx", "kotlin" }
                                        if not vim.list_contains(disable_indent, ft) then
                                                vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                                        end
                                end,
                        })
                end
        }
}
