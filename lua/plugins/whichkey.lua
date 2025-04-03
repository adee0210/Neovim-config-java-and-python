return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps",
        },
        {
            "<leader>g",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Github",
        },
        {
            "<leader>M",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Phát nhạc",
        },
        {
            "<leader>j",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Java",
        },
        {
            "<leader>C",
            function()
                require("which-key").show({ global = false })
            end,

            desc = " AI Chat",
        },
        {
            "<leader>d",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Cửa sổ Debug",
        },
        {
            "<leader>f",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Thao tác với tệp",
        },
        {
            "<leader>m",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Thao tác với Markdown",
        },
        {
            "<leader>c",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Thao tác với source code",
        },
        {
            "<leader>P",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Python",
        },
        {
            "<leader>w",
            function()
                require("which-key").show({ global = false })
            end,
            desc = " Chia ngang/dọc màn hình",
        },

    },
}
