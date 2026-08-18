local M = {}

local function split_lines(text)
    local lines = {}

    for line in (text .. "\n"):gmatch("(.-)\r?\n") do
        table.insert(lines, line)
    end

    return lines
end

function M.response(prompt, response)
    local lines = {}

    -- Prompt
    vim.list_extend(
        lines,
        split_lines(prompt)
    )

    table.insert(lines, "")

    -- Response
    table.insert(lines, "haai:")
    table.insert(lines, "")

    vim.list_extend(
        lines,
        split_lines(response)
    )

    return lines
end

function M.clear(buf)
    vim.bo[buf].modifiable = true

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        { "" }
    )
end

function M.set(buf, lines)
    vim.bo[buf].modifiable = true

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        lines
    )

    vim.bo[buf].modifiable = false
end

return M
