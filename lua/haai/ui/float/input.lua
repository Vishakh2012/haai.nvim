local state = require("haai.ui.float.state").state
local input_field_ui = require("haai.ui.float.input_field_ui")
local content = require("haai.ui.float.content")
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

    content.append(prompt, response)

    -- Every question is independent.
    input_field_ui.clear()

    -- The initial selection only applies to the first query.
    state.selection = nil

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
