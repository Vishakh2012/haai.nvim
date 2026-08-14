local M = {}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend(
    "force",
    M.options,
    opts or {}
  )

  require("haai.model").setup(M.options)
end

function M.ask(prompt, selection)
  return require("haai.model").ask(prompt, selection)
end

return M
