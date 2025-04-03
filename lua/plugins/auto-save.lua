return {
    "okuuva/auto-save.nvim",
    version = "*",
    event = { "BufLeave", "FocusLost", "VimLeavePre" },
    opts = {
        enabled = true,
        trigger_events = {
            immediate_save = { "BufLeave", "FocusLost", "VimLeavePre" },
            defer_save = {},
        },
        cancel_deferred_save = {},
        write_all_buffers = true,
        debounce_delay = 0,
        noautocmd = true,
        lockmarks = false,
        debug = false,
        execution_function = function()
            local current_win = vim.api.nvim_get_current_win()
            vim.api.nvim_command("silent! wall")
            vim.api.nvim_set_current_win(current_win)
        end,
    },
    config = function(_, opts)
        require("auto-save").setup(opts)
    end,
}
