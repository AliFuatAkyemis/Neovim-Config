return {
        {
                "nvim-treesitter/nvim-treesitter",
                branch = 'master',
                lazy = false,
                build = ":TSUpdate",
                config = function()
                        require("nvim-treesitter.configs").setup({
                                ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
                                sync_install = false,
                                auto_install = false,
                                highlight = {
                                        enable = true,
                                        disable = { "markdown", "markdown_inline" },
                                        additional_vim_regex_highlighting = false,
                                },
                        })
                end
        }
}
