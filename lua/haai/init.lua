local M = {}

function M.setup(opts)
  opts = opts or {}
end

function M.open()
  require("haai.ui.float").open()
end

return M
