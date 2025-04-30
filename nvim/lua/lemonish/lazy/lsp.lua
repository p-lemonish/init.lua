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
        "rafamadriz/friendly-snippets",
        {
          "L3MON4D3/LuaSnip",
          dependencies = { "rafamadriz/friendly-snippets" },
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        'numToStr/Comment.nvim',
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local luasnip = require("luasnip")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})

        -- Auto format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })

        -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
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

            },
            require("conform").setup({
                formatters_by_ft = {
                    lua        = { "stylua" },
                    python     = { "black" },
                    javascript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    typescript = { "prettier" },
                    html       = { "prettier" },
                    terraform  = { "terraform_fmt" },
                    ruby       = { "rubocop" },
                    go         = { "gofmt" },
                },
            })
        })
    end
}
