local M = {}

M.state = {
    buf = nil,
    win = nil,
    selection = nil,
}

function M.reset()
    M.state.buf = nil
    M.state.win = nil
    M.state.selection = nil
end

return M
