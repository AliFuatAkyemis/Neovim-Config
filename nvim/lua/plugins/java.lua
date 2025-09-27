return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            local jdtls = require('jdtls')
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
                        },
                        -- Add this section to enable documentation
                        completion = {
                            favoriteStaticMembers = {
                                "org.junit.Assert.*",
                                "org.junit.Assume.*",
                                "org.junit.jupiter.api.Assertions.*",
                                "org.junit.jupiter.api.Assumptions.*",
                                "org.junit.jupiter.api.DynamicContainer.*",
                                "org.junit.jupiter.api.DynamicTest.*",
                                "org.mockito.Mockito.*",
                                "org.mockito.ArgumentMatchers.*",
                                "org.mockito.Answers.*"
                            },
                            filteredTypes = {
                                "com.sun.*",
                                "io.micrometer.shaded.*",
                                "java.awt.*",
                                "jdk.*",
                                "sun.*",
                            },
                        },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                        -- Enable import of library sources
                        import = {
                            gradle = {
                                enabled = true
                            },
                            maven = {
                                enabled = true
                            }
                        }
                    }
                },
                init_options = {
                    bundles = {},
                    -- This helps with documentation features
                    extendedClientCapabilities = {
                        classFileContentsSupport = true,
                        generateToStringPromptSupport = true,
                        hashCodeEqualsPromptSupport = true,
                        advancedOrganizeImportsSupport = true,
                        resolveAdditionalTextEditsSupport = true,
                        advancedGenerateAccessorsSupport = true,
                    },
                }
            }
            
            require('jdtls').start_or_attach(config)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'java',
                callback = function()
                    jdtls.start_or_attach(config)
                    
                    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, { buffer = true, desc = "Organize imports" })
                    vim.keymap.set('n', '<leader>jt', jdtls.test_class, { buffer = true, desc = "Test class" })
                    vim.keymap.set('n', '<leader>jT', jdtls.test_nearest_method, { buffer = true, desc = "Test method" })
                    
                    -- Add documentation specific mappings
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true, desc = "Show documentation" })
                    vim.keymap.set('n', '<leader>jd', vim.lsp.buf.definition, { buffer = true, desc = "Go to definition" })
                end
            })
        end
    }
}
