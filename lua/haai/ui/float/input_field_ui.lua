local state = require("haai.ui.float.state").state

local M = {}

function M.create(parent_win)
    local config = vim.api.nvim_win_get_config(parent_win)

    local width = config.width - 4
    local height = 3

    local buf = vim.api.nvim_create_buf(false, true)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "haai-input"

    local win = vim.api.nvim_open_win(
        buf,
        false,
        {
            relative = "win",
            win = parent_win,
            width = width,
            height = height,
            row = config.height - height - 2,
            col = 2,
            style = "minimal",
            border = "rounded",
        }
    )

    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
    vim.wo[win].breakindent = true

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        { "" }
    )

    state.input_buf = buf
    state.input_win = win

    return win
end

function M.resize(parent_win)
    if not state.input_win
        or not vim.api.nvim_win_is_valid(state.input_win)
    then
        return
    end

    local config = vim.api.nvim_win_get_config(parent_win)

    local width = config.width - 4
    local height = 3

    vim.api.nvim_win_set_config(
        state.input_win,
        {
            relative = "win",
            win = parent_win,
            width = width,
            height = height,
            row = config.height - height - 2,
            col = 2,
            style = "minimal",
            border = "rounded",
        }
    )
end

function M.clear()
    if not state.input_buf
        or not vim.api.nvim_buf_is_valid(state.input_buf)
    then
        return
    end

    vim.bo[state.input_buf].modifiable = true

    vim.api.nvim_buf_set_lines(
        state.input_buf,
        0,
        -1,
        false,
        { "" }
    )

    vim.bo[state.input_buf].modifiable = true
end

function M.get_text()
    if not state.input_buf
        or not vim.api.nvim_buf_is_valid(state.input_buf)
    then
        return ""
    end

    local lines = vim.api.nvim_buf_get_lines(
        state.input_buf,
        0,
        -1,
        false
    )

    return vim.trim(table.concat(lines, "\n"))
end

function M.focus()
    if state.input_win
        and vim.api.nvim_win_is_valid(state.input_win)
    then
        vim.api.nvim_set_current_win(state.input_win)
        vim.cmd("startinsert")
    end
end

return M
