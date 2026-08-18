local state = require("haai.ui.float.state").state
local input_field_ui = require("haai.ui.float.input_field_ui")
local window = require("haai.ui.float.window")

local M = {}

function M.submit()
    local prompt = input_field_ui.get_text()

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

        input_field_ui.focus()
        return
    end

    -- Outer window buffer.
    vim.bo[state.content_buf].modifiable = true

    local function split_lines(text)
        local lines = {}

        for line in (text .. "\n"):gmatch("(.-)\r?\n") do
            table.insert(lines, line)
        end

        return lines
    end

    local output_lines = {}

    -- Previous/current query.
    table.insert(output_lines, "You:")
    table.insert(output_lines, "")

    vim.list_extend(
        output_lines,
        split_lines(prompt)
    )

    table.insert(output_lines, "")

    -- Response.
    table.insert(output_lines, "HAAI:")
    table.insert(output_lines, "")

    vim.list_extend(
        output_lines,
        split_lines(response)
    )

    table.insert(output_lines, "")

    vim.api.nvim_buf_set_lines(
        state.content_buf,
        -1,
        -1,
        false,
        output_lines
    )

    vim.bo[state.content_buf].modifiable = false

    -- Clear input for the next question.
    input_field_ui.clear()

    -- Selection belongs only to the first request.
    state.selection = nil

    -- Return focus to input.
    input_field_ui.focus()
end

function M.setup()
    vim.keymap.set("i", "<CR>", M.submit, {
        buffer = state.input_buf,
        silent = true,
    })

    vim.keymap.set("n", "<CR>", function()
        input_field_ui.focus()
    end, {
        buffer = state.input_buf,
        silent = true,
    })

    vim.keymap.set({ "n", "i" }, "<Esc>", window.close, {
        buffer = state.input_buf,
        silent = true,
    })
end

return M
