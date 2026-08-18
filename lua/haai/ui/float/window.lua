local state = require("haai.ui.float.state").state
local input_field_ui = require("haai.ui.float.input_field_ui")

local M = {}

function M.get_width()
    return math.floor(vim.o.columns * 0.8)
end

function M.get_max_height()
    return math.floor(vim.o.lines * 0.7)
end

function M.get_position(width, height)
    local cursor = vim.api.nvim_win_get_cursor(0)

    local cursor_row = cursor[1] - 1
    local cursor_col = cursor[2]

    local row = cursor_row - height

    if row < 0 then
        row = cursor_row + 1
    end

    local col = cursor_col - math.floor(width / 2)

    col = math.max(0, col)

    if col + width > vim.o.columns then
        col = vim.o.columns - width
    end

    return row, col
end

function M.create()
    local width = M.get_width()
    local height = 10

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    state.content_buf = vim.api.nvim_create_buf(false, true)

    vim.bo[state.content_buf].buftype = "nofile"
    vim.bo[state.content_buf].bufhidden = "wipe"
    vim.bo[state.content_buf].swapfile = false
    vim.bo[state.content_buf].filetype = "haai"

    state.win = vim.api.nvim_open_win(
        state.content_buf,
        true,
        {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "rounded",
        }
    )

    vim.wo[state.win].wrap = true
    vim.wo[state.win].linebreak = true
    vim.wo[state.win].breakindent = true

    -- Create the input field inside this window.
    input_field_ui.create(state.win)

    return state.win
end

function M.resize()
    if not state.win
        or not vim.api.nvim_win_is_valid(state.win)
    then
        return
    end

    local width = M.get_width()

    vim.api.nvim_win_set_width(
        state.win,
        width
    )

    input_field_ui.resize(state.win)
end

function M.close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end

    require("haai.ui.float.state").reset()
end

return M
