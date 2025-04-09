return {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")
        require("nvim-treesitter.configs").setup({
            rainbow = {
                enable = true,
                strategy = rainbow_delimiters.strategy["global"],
                query = {
                    [""] = "rainbow-delimiters",      -- Query mặc định
                    tsx = "rainbow-parens",           -- Dành riêng cho .tsx
                    javascript = "rainbow-parens",    -- Dành riêng cho .js
                },
                hlgroups = {
                    "#FF6B6B", -- Đỏ tươi (Red)
                    "#4ECDC4", -- Cyan ngọc (Turquoise) 
                    "#FFD700", -- Vàng ánh kim (Gold)
                    "#FF69B4", -- Hồng phấn (Hot Pink)
                    "#7FFF00", -- Xanh chartreuse (Chartreuse)
                    "#00CED1", -- Xanh ngọc lam (Dark Turquoise)
                    "#FF4500", -- Cam đỏ (Orange Red)
                    "#DA70D6", -- Tím hoa cà (Orchid)
                    "#32CD32", -- Xanh lá lime (Lime Green)
                    "#1E90FF", -- Xanh dương sáng (Dodger Blue)
                    "#FFB6C1", -- Hồng nhạt (Light Pink)
                    "#ADFF2F", -- Xanh lá vàng (Green Yellow)
                },
            },
        })
    end,
}
