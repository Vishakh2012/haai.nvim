local state = require("haai.ui.float.state").state

local M = {}

function M.get_width()
    return math.floor(vim.o.columns * 0.8)
end

function M.get_max_height()
    return math.floor(vim.o.lines * 0.5)
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

function M.update_size()
    if not state.win or not vim.api.nvim_win_is_valid(state.win) then
        return
    end

    local width = M.get_width()
    local max_height = M.get_max_height()

    local line_count = vim.api.nvim_buf_line_count(state.buf)

    local wrapped_lines = 0

    for i = 1, line_count do
        local line = vim.api.nvim_buf_get_lines(
            state.buf,
            i - 1,
            i,
            false
        )[1] or ""

        wrapped_lines = wrapped_lines
            + math.max(
                1,
                math.ceil(
                    vim.fn.strdisplaywidth(line) / width
                )
            )
    end

    local height = math.max(
        1,
        math.min(wrapped_lines, max_height)
    )

    local row, col = M.get_position(width, height)

    vim.api.nvim_win_set_config(state.win, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
end

function M.configure()
    vim.wo[state.win].wrap = true
    vim.wo[state.win].linebreak = true
    vim.wo[state.win].breakindent = true
end

function M.close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end

    require("haai.ui.float.state").reset()
end

function M.create()
    local width = M.get_width()
    local height = 1

    local row, col = M.get_position(width, height)

    state.buf = vim.api.nvim_create_buf(false, true)

    vim.bo[state.buf].buftype = "nofile"
    vim.bo[state.buf].bufhidden = "wipe"
    vim.bo[state.buf].swapfile = false
    vim.bo[state.buf].filetype = "haai"

    state.win = vim.api.nvim_open_win(
        state.buf,
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

    M.configure()

    return state.buf, state.win
end

return M
