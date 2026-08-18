local state = require("haai.ui.float.state").state
local window = require("haai.ui.float.window")
local input = require("haai.ui.float.input")
local input_field_ui = require("haai.ui.float.input_field_ui")


local M = {}

function M.open(selection)
    state.selection = selection

    if state.win and vim.api.nvim_win_is_valid(state.win) then
        input.focus()
        return
    end

    window.create()

    input.setup()

    input_field_ui.focus()
end

return M
