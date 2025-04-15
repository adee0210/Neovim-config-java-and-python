local M = {}

-- Lưu trạng thái playlist cho các thư mục
M.playlists = {
    coloi = nil,
    khongloi = nil,
}
M.active_playlist = nil -- Lưu loại playlist đang phát ("coloi" hoặc "khongloi")

-- Hàm xáo trộn (Fisher-Yates)
local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

-- Hàm chơi bài hiện tại trong playlist của một loại
local function play_current_song(playlist_type)
    local playlist = M.playlists[playlist_type]
    if not playlist or not playlist.files then
        vim.notify("Playlist không tồn tại", vim.log.levels.ERROR)
        return
    end

    local file = playlist.files[playlist.index]
    if not file then
        vim.notify("Không còn bài nào trong danh sách", vim.log.levels.INFO)
        return
    end

    -- Kill mpv hiện tại (nếu có) rồi phát file mới
    vim.fn.system("pkill -9 mpv")
    local cmd = { "mpv", "--no-video", file }
    vim.fn.jobstart(cmd, { detach = true })
    vim.notify("Đang phát: " .. file, vim.log.levels.INFO)
end

-- Hàm khởi chạy playlist mới cho thư mục chỉ định
local function start_playlist(playlist_type)
    local path = nil
    if playlist_type == "coloi" then
        path = "/home/duc/Music/Coloi"
    elseif playlist_type == "khongloi" then
        path = "/home/duc/Music/Khongloi"
    else
        vim.notify("Playlist type không hợp lệ", vim.log.levels.ERROR)
        return
    end

    if vim.fn.isdirectory(path) == 0 then
        vim.notify("Thư mục không tồn tại: " .. path, vim.log.levels.ERROR)
        return
    end

    local files = vim.fn.glob(path .. "/*", true, true)
    if not files or type(files) ~= "table" or #files == 0 then
        vim.notify("Không tìm thấy file nhạc trong " .. path, vim.log.levels.ERROR)
        return
    end

    shuffle(files)
    -- Lưu trạng thái playlist: danh sách file, index bắt đầu từ 1 và đường dẫn
    M.playlists[playlist_type] = { files = files, index = 1, dir = path }
    M.active_playlist = playlist_type

    play_current_song(playlist_type)
end

-- Hàm chuyển sang bài tiếp theo trong playlist đang hoạt động
local function play_next_song()
    if not M.active_playlist then
        vim.notify("Không có playlist nào đang hoạt động", vim.log.levels.ERROR)
        return
    end

    local playlist = M.playlists[M.active_playlist]
    if not playlist then
        vim.notify("Playlist không tồn tại", vim.log.levels.ERROR)
        return
    end

    playlist.index = playlist.index + 1
    if playlist.index > #playlist.files then
        vim.notify("Đã hết danh sách phát", vim.log.levels.INFO)
        return
    end
    play_current_song(M.active_playlist)
end

-- Hàm tạm dừng / tiếp tục phát nhạc
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

-- Hàm tắt nhạc hoàn toàn (kill mpv)
local function kill_music()
    vim.fn.system("pkill -9 mpv")
    vim.notify("Đã tắt hoàn toàn nhạc", vim.log.levels.INFO)
    M.active_playlist = nil
end

-- Gán phím với mô tả
function M.setup()
    vim.api.nvim_set_keymap("n", "<leader>Mp", "", {
        callback = function() start_playlist("coloi") end,
        noremap = true,
        silent = false,
        desc = "Phát playlist Coloi (shuffle, không lặp lại)"
    })
    vim.api.nvim_set_keymap("n", "<leader>Mk", "", {
        callback = function() start_playlist("khongloi") end,
        noremap = true,
        silent = false,
        desc = "Phát playlist Khongloi (shuffle, không lặp lại)"
    })
    vim.api.nvim_set_keymap("n", "<leader>Mn", "", {
        callback = play_next_song,
        noremap = true,
        silent = false,
        desc = "Chuyển sang bài tiếp theo trong playlist"
    })
    vim.api.nvim_set_keymap("n", "<leader>Mt", "", {
        callback = toggle_music,
        noremap = true,
        silent = false,
        desc = "Tạm dừng / tiếp tục phát nhạc"
    })
    vim.api.nvim_set_keymap("n", "<leader>Ms", "", {
        callback = kill_music,
        noremap = true,
        silent = false,
        desc = "Tắt hoàn toàn nhạc (kill mpv)"
    })
end

M.setup()
return M
