return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Simplified DAP UI setup
        dapui.setup({
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.5 },    -- Variables
                        { id = "breakpoints", size = 0.5 }, -- Breakpoints
                    },
                    size = 40,
                    position = "left",
                },
                {
                    elements = {
                        { id = "console", size = 1.0 },   -- Console only
                    },
                    size = 10,
                    position = "bottom",
                },
            },
            controls = {
                enabled = true,
                element = "console",
                icons = { pause = "⏸", play = "▶", step_into = "↓", step_over = "→", step_out = "↑", terminate = "⏹" },
            },
        })

        -- Auto-open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.after.event_stopped["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

        -- Define signs
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
        vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn" })

        -- Keybindings
        vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "[D]ebug [C]lose" })
        vim.keymap.set("n", "<leader>du", dapui.open, { desc = "[D]ebug [U]I Open" })
    end,
}
