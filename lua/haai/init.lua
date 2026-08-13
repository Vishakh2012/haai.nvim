local M = {}

function M.open()
  local selection = require("haai.ui.selection").get()

  require("haai.ui.float").open(selection)
end

return M
