local M = {}

function M.setup(opts)
    require("haai.config").setup(opts)
end

function M.ask(prompt, selection)
    return require("haai.config").ask(prompt, selection)
end

function M.open(selection)
    require("haai.ui.float").open(selection)
end

return M
