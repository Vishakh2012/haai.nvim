local M = {}

local state = {
    buf = nil,
    win = nil,
}

local function get_width()
    -- Leave a little space on both sides.
    return math.floor(vim.o.columns * 0.8)
end

local function get_max_height()
    return math.floor(vim.o.lines * 0.5)
end

local function get_position(width, height)
    local cursor = vim.api.nvim_win_get_cursor(0)

    local cursor_row = cursor[1] - 1
    local cursor_col = cursor[2]

    -- Put the window one line above the cursor.
    local row = cursor_row - height

    -- If there isn't enough space above, put it below.
    if row < 0 then
        row = cursor_row + 1
    end

    -- Keep the window horizontally around the cursor.
    local col = cursor_col - math.floor(width / 2)

    col = math.max(0, col)

    if col + width > vim.o.columns then
        col = vim.o.columns - width
    end

    return row, col
end

local function close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end

    state.win = nil
    state.buf = nil
end

local function update_size()
    if not state.win or not vim.api.nvim_win_is_valid(state.win) then
        return
    end

    local width = get_width()
    local max_height = get_max_height()

    local line_count = vim.api.nvim_buf_line_count(state.buf)

    -- Minimum 1 line, maximum half the screen.
    local height = math.max(1, math.min(line_count, max_height))

    local row, col = get_position(width, height)

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
local function submit()
    print("=== HAAI DEBUG: submit() ===")

    print("state.buf:", state.buf)
    print("state.win:", state.win)

    local lines = vim.api.nvim_buf_get_lines(
        state.buf,
        0,
        -1,
        false
    )

    print("input lines:")
    for i, line in ipairs(lines) do
        print("  [" .. i .. "] " .. line)
    end

    local prompt = table.concat(lines, "\n")
    prompt = vim.trim(prompt)

    print("prompt:", vim.inspect(prompt))
    print("selection:", vim.inspect(state.selection))

    if prompt == "" then
        print("HAAI DEBUG: empty prompt, returning")
        return
    end

    vim.cmd("stopinsert")

    print("HAAI DEBUG: loading config")

    local config = require("haai.config")

    print("HAAI DEBUG: config loaded:", vim.inspect(config))

    print("HAAI DEBUG: calling config.ask()")

    local response, err = config.ask(
        prompt,
        state.selection
    )

    print("HAAI DEBUG: config.ask() returned")
    print("response:", vim.inspect(response))
    print("error:", vim.inspect(err))

    if not response then
        print("HAAI DEBUG: request failed")

        vim.notify(
            "HAAI error: " .. tostring(err),
            vim.log.levels.ERROR
        )

        return
    end

    print("HAAI DEBUG: response received")

    vim.bo[state.buf].modifiable = true

    local output_lines = {
        prompt,
        "",
    }

    if state.selection and state.selection ~= "" then
        table.insert(output_lines, "selected:")
        table.insert(output_lines, "")

        for line in state.selection:gmatch("[^\r\n]+") do
            table.insert(output_lines, line)
        end

        table.insert(output_lines, "")
    end

    table.insert(output_lines, "haai:")
    table.insert(output_lines, "")
    table.insert(output_lines, response)

    print("HAAI DEBUG: writing response to buffer")

    vim.api.nvim_buf_set_lines(
        state.buf,
        0,
        -1,
        false,
        output_lines
    )

    vim.bo[state.buf].modifiable = false

    update_size()

    vim.keymap.set("n", "q", close, {
        buffer = state.buf,
        silent = true,
    })

    vim.keymap.set("n", "<Esc>", close, {
        buffer = state.buf,
        silent = true,
    })

    vim.api.nvim_win_set_cursor(
        state.win,
        { 1, 0 }
    )

    print("=== HAAI DEBUG: submit() finished ===")
end

function M.open(selection)
    state.selection = selection
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_set_current_win(state.win)
        return
    end

    local width = get_width()

    -- Initially exactly one line.
    local height = 1

    local row, col = get_position(width, height)

    state.buf = vim.api.nvim_create_buf(false, true)

    vim.bo[state.buf].buftype = "nofile"
    vim.bo[state.buf].bufhidden = "wipe"
    vim.bo[state.buf].swapfile = false
    vim.bo[state.buf].filetype = "haai"

    state.win = vim.api.nvim_open_win(state.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_lines(
        state.buf,
        0,
        -1,
        false,
        { "" }
    )

    vim.keymap.set("i", "<CR>", submit, {
        buffer = state.buf,
        silent = true,
    })

    vim.keymap.set({ "n", "i" }, "<Esc>", close, {
        buffer = state.buf,
        silent = true,
    })

    vim.cmd("startinsert")
end

return M
