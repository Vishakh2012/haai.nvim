local state = require("haai.ui.float.state").state
local window = require("haai.ui.float.window")
local render = require("haai.ui.float.render")

local M = {}

function M.submit()
    local lines = vim.api.nvim_buf_get_lines(
        state.buf,
        0,
        -1,
        false
    )

    local prompt = table.concat(lines, "\n")
    prompt = vim.trim(prompt)

    if prompt == "" then
        return
    end

    vim.cmd("stopinsert")

    local config = require("haai.config")

    local response, err = config.ask(
        prompt,
        state.selection
    )

    if not response then
        vim.notify(
            "haai error: " .. tostring(err),
            vim.log.levels.ERROR
        )

        return
    end

    render.set(
        state.buf,
        render.response(prompt, response)
    )

    window.update_size()

    vim.keymap.set("n", "q", window.close, {
        buffer = state.buf,
        silent = true,
    })

    vim.keymap.set("n", "<Esc>", window.close, {
        buffer = state.buf,
        silent = true,
    })

    vim.api.nvim_win_set_cursor(
        state.win,
        { 1, 0 }
    )
end

return M
