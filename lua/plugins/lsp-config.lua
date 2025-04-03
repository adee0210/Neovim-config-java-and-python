return {
    -- Mason.nvim
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    -- Mason-lspconfig.nvim
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",                    -- LSP cho Python
                    "lua_ls",                     -- Lua
                    "ts_ls",                      -- TypeScript/JavaScript
                    "html",                       -- HTML
                    "cssls",                      -- CSS
                    "groovyls",                   -- Groovy
                    "jdtls",                      -- LSP cho Java
                    "kotlin_language_server",      
                },
                automatic_installation = true, -- Tự động cài đặt khi khởi động
            })
        end,
    },
      -- Mason DAP (for debug adapters)
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "java-debug-adapter",
                    "java-test"
                },
                automatic_installation = true,
            })
        end,
    },


    -- Thêm các plugin cho nvim-cmp
    {
        "hrsh7th/cmp-path", -- Gợi ý đường dẫn
    },
    {
        "hrsh7th/cmp-nvim-lsp", -- Gợi ý từ LSP
    },
    {
        "L3MON4D3/LuaSnip", -- Snippet engine
        dependencies = {
            "saadparwaiz1/cmp_luasnip", -- Tích hợp LuaSnip với nvim-cmp
            "rafamadriz/friendly-snippets", -- Thư viện snippet
        },
    },
    {
        "hrsh7th/nvim-cmp", -- Plugin chính cho code completion
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "jmbuhr/otter.nvim", -- Tích hợp otter.nvim cho .md/.qmd
            "hrsh7th/cmp-buffer", -- Thêm lại để hỗ trợ nguồn buffer
            "hrsh7th/cmp-path", -- Thêm lại để hỗ trợ nguồn path
        },
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load() -- Tải snippet từ VSCode

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- Mở rộng snippet
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- Mở menu gợi ý
                    ["<C-e>"] = cmp.mapping.abort(), -- Đóng menu gợi ý
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Chấp nhận gợi ý
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            vim.fn.feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                                ""
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require("luasnip").jumpable(-1) then
                            vim.fn.feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true),
                                ""
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- Gợi ý từ LSP
                    { name = "luasnip" }, -- Gợi ý từ snippet
                    { name = "otter" }, -- Gợi ý từ otter.nvim cho .md/.qmd
                    { name = "path" }, -- Gợi ý đường dẫn
                }, {
                    { name = "buffer" }, -- Gợi ý từ buffer
                }),
            })
        end,
    },

    -- Plugin nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "mfussenegger/nvim-jdtls",
            "stevearc/conform.nvim",
            "akinsho/toggleterm.nvim",
            "quarto-dev/quarto-nvim",
            "jmbuhr/otter.nvim",
            "hrsh7th/cmp-nvim-lsp", -- Đảm bảo tích hợp với nvim-cmp
        },
        config = function()
            -- Cấu hình conform.nvim để dùng black cho Python
            require("conform").setup({
                formatters_by_ft = {
                    python = { "black" }, -- Dùng black để định dạng Python
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true, -- Dùng LSP nếu formatter không khả dụng
                },
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Cấu hình LSP
            require("config.pyright").setup_pyright()
            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.ts_ls.setup({ capabilities = capabilities })
            lspconfig.html.setup({ capabilities = capabilities })
            lspconfig.cssls.setup({ capabilities = capabilities })
            lspconfig.groovyls.setup({
                capabilities = capabilities,
                filetypes = { "groovy" },
                root_dir = lspconfig.util.root_pattern(".git", "gradlew", "build.gradle", "pom.xml"),
            })
            lspconfig.kotlin_language_server.setup({
                capabilities = capabilities,
                filetypes = { "kotlin", "kts" },
                root_dir = lspconfig.util.root_pattern(".git", "build.gradle.kts", "pom.xml"),
            })

            -- Phím tắt LSP
            vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "Tài liệu khi di chuột qua mã" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Đi đến định nghĩa mã" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Hành động mã" })
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "Đi đến tham chiếu mã" })
            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "Đi đến triển khai mã" })
            vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "Đổi tên mã" })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Đi đến khai báo mã" })

            -- Autocommands
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    require("config.jdtls").setup_jdtls()
                end,
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "kotlin", "kts" },
                callback = function()
                    require("config.jdtls").setup_kotlin()
                end,
            })
        end,
    },
}
