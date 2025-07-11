return {
        {
                "mfussenegger/nvim-jdtls",
                ft = "java",
                dependencies = { "neovim/nvim-lspconfig" },
                config = function()
                        local jdtls = require('jdtls')

                        local jdtls_path = vim.fn.stdpath("data") .. "mason/packages/jdtls"
                        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

                        local config = {
                                cmd = {
                                        'java',
                                        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                                        '-Dosgi.bundles.defaultStartLevel=4',
                                        '-Declipse.product=org.eclipse.jdt.ls.core.product',
                                        '-Dlog.protocol=true',
                                        '-Dlog.level=ALL',
                                        '-Xms1g',
                                        '--add-modules=ALL-SYSTEM',
                                        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                                        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                                        '-jar', vim.fn.glob('~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
                                        '-configuration', vim.fn.glob('~/.local/share/nvim/mason/packages/jdtls/config_linux'),
                                        '-data', vim.fn.getcwd() .. '/.jdtls-workspace'
                                },
                                root_dir = jdtls.setup.find_root({ '.git', 'gradlew', 'mvnw', 'pom.xml' }),
                                settings = {
                                        java = {
                                                configuration = {
                                                        updateBuildConfiguration = "interactive",
                                                        runtimes = {
                                                                { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk-amd64"}
                                                        }
                                                }
                                        }
                                },
                                init_options = { bundles = {} }
                        }
                        require('jdtls').start_or_attach(config)

                        vim.api.nvim_create_autocmd('FileType', {
                                pattern = 'java',
                                callback = function()
                                        jdtls.start_or_attach(config)
                                        
                                        vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, { buffer = true, desc = "Organize imports" })
                                        vim.keymap.set('n', '<leader>jt', jdtls.test_class, { buffer = true, desc = "Test class" })
                                        vim.keymap.set('n', '<leader>jT', jdtls.test_nearest_method, { buffer = true, desc = "Test method" })
                                end
                        })
                end
        }
}
