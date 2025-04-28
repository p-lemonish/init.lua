return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "mfussenegger/nvim-jdtls",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        'numToStr/Comment.nvim',
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        -- Auto format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                vim.lsp.buf.format()
            end
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").expand_or_jumpable() then
                        require("luasnip").expand_or_jump()
                    else
                        fallback()  -- Default tab behavior
                    end
                end, { "i", "s" }), -- Works in insert and select mode
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()  -- Default tab behavior
                    end
                end, { "i", "s" }), -- Works in insert and select mode
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        require("Comment").setup()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "ruby_lsp", -- must do apt install gem and apt install ruby-dev, then do gem install ruby-lsp.
                "lua_ls",
                "terraformls",
                "ts_ls",
                "html",
                "pyright",
                "gopls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.2" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["terraformls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup({
                        capabilities = capabilities,
                    })
                end,
                ["ruby_lsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ruby_lsp.setup({
                        capabilities = capabilities,
                    })
                end,
                -- Java LSP setup
                ["jdtls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.jdtls.setup({
                        capabilities = capabilities,
                    })
                end,

                -- JavaScript/TypeScript LSP setup
                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            javascript = {
                                format = {
                                    semicolons = "insert"
                                }
                            },
                            typescript = {
                                format = {
                                    semicolons = "insert"
                                }
                            }
                        }
                    })
                end,

                -- HTML LSP setup
                ["html"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.html.setup({
                        capabilities = capabilities
                    })
                end,

                -- Python LSP setup
                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "strict",
                                    autoImportCompletions = true,
                                }
                            }
                        }
                    })
                end,
            }
        })
    end
}
