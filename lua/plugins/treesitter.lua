return {
        {
                "nvim-treesitter/nvim-treesitter",
                branch = 'master',
                lazy = false,
                build = ":TSUpdate",
                config = function()
                        require("nvim-treesitter.configs").setup({
                                ensure_installed = { 
                                        "c", "lua", "vim", "vimdoc", "query", "python",
                                        "javascript", "typescript", "tsx", "html", "css", 
                                        "json", "yaml", "bash", "dockerfile", "go", "rust", "cpp",
                                        "markdown", "markdown_inline", "angular"
                                },
                                sync_install = false,
                                auto_install = false,
                                highlight = {
                                        enable = true,
                                        disable = {},
                                        additional_vim_regex_highlighting = false,
                                },
                                indent = {
                                        enable = true,
                                        disable = { "html", "htmlangular", "javascript", "typescript", "tsx" }
                                },
                        })
                        vim.treesitter.language.register("angular", "htmlangular")
                end
        }
}
