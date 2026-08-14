local M = {}

function M.setup(opts)
    require("haai.config").setup(opts)
end

function M.ask(prompt, selection)
    return require("haai.config").ask(prompt, selection)
end

function M.open()
    local selection = nil

    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == "\22" then
        selection = require("haai.ui.selection").get()

        print("HAAI selection:", vim.inspect(selection))
    end

    require("haai.ui.float").open(selection)
end

return M
