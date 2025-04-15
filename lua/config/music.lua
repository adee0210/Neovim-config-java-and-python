local M = {}

-- Phát nhạc shuffle từ thư mục Coloi
local function play_music()
    local path = "/home/duc/Music/Coloi"
    if vim.fn.isdirectory(path) == 0 then
        vim.notify("Thư mục Coloi không tồn tại", vim.log.levels.ERROR)
        return
    end

    local cmd = { "mpv", "--no-video", "--shuffle", path }
    vim.fn.jobstart(cmd, { detach = true })
    vim.notify("Đang phát nhạc (shuffle) từ Coloi", vim.log.levels.INFO)
end

-- Phát nhạc shuffle từ thư mục Khongloi
local function play_music_khongloi()
    local path = "/home/duc/Music/Khongloi"
    if vim.fn.isdirectory(path) == 0 then
        vim.notify("Thư mục Khongloi không tồn tại", vim.log.levels.ERROR)
        return
    end

    local cmd = { "mpv", "--no-video", "--shuffle", path }
    vim.fn.jobstart(cmd, { detach = true })
    vim.notify("Đang phát nhạc (shuffle) từ Khongloi", vim.log.levels.INFO)
end

-- Tạm dừng / phát tiếp
local function toggle_music()
    local check_running = vim.fn.system("pgrep mpv")
    if vim.v.shell_error ~= 0 then
        vim.notify("Không có mpv đang chạy", vim.log.levels.WARN)
        return
    end

    local check_paused = vim.fn.system("ps -C mpv -o state | grep T")
    if vim.v.shell_error == 0 then
        vim.fn.system("pkill -SIGCONT mpv")
        vim.notify("Tiếp tục phát nhạc", vim.log.levels.INFO)
    else
        vim.fn.system("pkill -SIGSTOP mpv")
        vim.notify("Đã tạm dừng nhạc", vim.log.levels.INFO)
    end
end

-- Tắt nhạc hoàn toàn
local function kill_music()
    vim.fn.system("pkill -9 mpv")
    vim.notify("Đã tắt hoàn toàn nhạc", vim.log.levels.INFO)
end

-- Gán phím
function M.setup()
    vim.api.nvim_set_keymap("n", "<leader>Mp", "", {
        callback = play_music,
        noremap = true,
        silent = false,
        desc = "Phát shuffle nhạc Coloi"
    })
    vim.api.nvim_set_keymap("n", "<leader>Mk", "", {
        callback = play_music_khongloi,
        noremap = true,
        silent = false,
        desc = "Phát shuffle nhạc Khongloi"
    })
    vim.api.nvim_set_keymap("n", "<leader>Mt", "", {
        callback = toggle_music,
        noremap = true,
        silent = false,
        desc = "Tạm dừng / tiếp tục nhạc"
    })
    vim.api.nvim_set_keymap("n", "<leader>Ms", "", {
        callback = kill_music,
        noremap = true,
        silent = false,
        desc = "Tắt nhạc (kill mpv)"
    })
end

M.setup()

return M
