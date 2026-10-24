-- quit after 1 hour without input so idle instances (and their LSPs) don't sit in RAM; stays open if anything is unsaved
if vim.env.BATTERY_SAVING == "true" then
    local idle_quit_timer = vim.uv.new_timer()
    local function IS_ANY_BUFFER_UNSAVED()
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buffer].modified then
                return true
            end
        end
        return false
    end
    local function RESTART_IDLE_QUIT_TIMER()
        idle_quit_timer:start(60 * 60 * 1000, 0, vim.schedule_wrap(function()
            if not IS_ANY_BUFFER_UNSAVED() then
                vim.cmd("qall")
            end
        end))
    end
    vim.on_key(RESTART_IDLE_QUIT_TIMER)
    RESTART_IDLE_QUIT_TIMER()
end
