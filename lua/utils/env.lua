local M = {}

function M.load_env()
    local env_file = vim.fn.expand('~/.config/nvim/.env')
    if vim.fn.filereadable(env_file) ~= 1 then
        print("Cannot read .env file at " .. env_file)
        return
    end

    for _, line in ipairs(vim.fn.readfile(env_file)) do
        local key, value = line:match('^(%S+)%s*=%s*(.*)$')
        if key and value then
            value = value:gsub('%$([%w_]+)', function(var)
                return vim.env[var] or ''
            end)
            vim.env[key] = value
        end
    end
end

M.load_env()

return M
