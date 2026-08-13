local M = {}

function M.setup(opts)
  opts = opts or {}

  -- Configuration will go here later.
end

function M.open()
  local selection = require("haai.ui.selection").get()

  require("haai.ui.float").open(selection)
end

return M
