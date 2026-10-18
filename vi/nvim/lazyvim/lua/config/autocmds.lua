-- quit after 1 hour without input so idle instances (and their LSPs) don't sit in RAM; unsaved changes are discarded
if vim.env.BATTERY_SAVING == "true" then
    local idle_quit_timer = vim.uv.new_timer()
    local function RESTART_IDLE_QUIT_TIMER()
        idle_quit_timer:start(60 * 60 * 1000, 0, vim.schedule_wrap(function()
            vim.cmd("qall!")
        end))
    end
    vim.on_key(RESTART_IDLE_QUIT_TIMER)
    RESTART_IDLE_QUIT_TIMER()
end
