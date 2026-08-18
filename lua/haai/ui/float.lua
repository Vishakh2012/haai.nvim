local state = require("haai.ui.float.state").state
local window = require("haai.ui.float.window")
local input = require("haai.ui.float.input")

local M = {}

function M.open(selection)
    state.selection = selection

    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_set_current_win(state.win)
        return
    end

    window.create()

    vim.api.nvim_buf_set_lines(
        state.buf,
        0,
        -1,
        false,
        { "" }
    )

    vim.keymap.set("i", "<CR>", input.submit, {
        buffer = state.buf,
        silent = true,
    })

    vim.keymap.set({ "n", "i" }, "<Esc>", window.close, {
        buffer = state.buf,
        silent = true,
    })

    vim.cmd("startinsert")
end

return M
