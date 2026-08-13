local M = {}

function M.get()
    local mode = vim.fn.mode()

    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    local start_row = start_pos[2]
    local end_row = end_pos[2]

    -- Handle backwards selection.
    if start_row > end_row then
        start_row, end_row = end_row, start_row
    end

    local lines

    if mode == "V" then
        -- Linewise visual selection.
        lines = vim.api.nvim_buf_get_lines(
            0,
            start_row - 1,
            end_row,
            false
        )
    else
        -- Characterwise visual selection.
        local start_col = start_pos[3]
        local end_col = end_pos[3]

        if start_row == end_row and start_col > end_col then
            start_col, end_col = end_col, start_col
        elseif start_row > end_row then
            start_col, end_col = end_col, start_col
        end

        lines = vim.api.nvim_buf_get_text(
            0,
            start_row - 1,
            start_col - 1,
            end_row - 1,
            end_col,
            {}
        )
    end

    return table.concat(lines, "\n")
end

return M
