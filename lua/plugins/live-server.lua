return {
    "barrett-ruth/live-server.nvim",
    build = "npm install -g live-server",
    config = function()
        require("live-server").setup()
        -- phím tắt tùy chọn
        vim.keymap.set("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
        vim.keymap.set("n", "<leader>le", ":LiveServerStop<CR>", { desc = "Stop Live Server" })
    end,
}
