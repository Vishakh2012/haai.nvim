local M = {}

M.state = {
    win = nil,
    content_buf = nil,
    input_buf = nil,
    input_win = nil,
    selection = nil,
}

function M.reset()
    M.state.win = nil
    M.state.content_buf = nil
    M.state.input_buf = nil
    M.state.input_win = nil
    M.state.selection = nil
end

return M
