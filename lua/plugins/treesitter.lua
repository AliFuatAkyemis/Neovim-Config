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
                                        "json", "yaml", "bash", "dockerfile", "go", "rust", "cpp"
                                },
                                sync_install = false,
                                auto_install = false,
                                highlight = {
                                        enable = true,
                                        disable = { "markdown", "markdown_inline", "html" },
                                        additional_vim_regex_highlighting = false,
                                },
                                indent = {
                                        enable = true,
                                        disable = { "html", "javascript", "typescript", "tsx" }
                                },
                        })
                end
        }
}
