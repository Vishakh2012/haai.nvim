local guardrail_prompt = [[ you are an inline coding agent, that responds to the selected lines
                  the query make the response as concise as possible, it should not just go rambling
                  on and should be straight to the point, here is the total query:]]


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
    local total_prompt = guardrail_prompt .. " " .. prompt
  return require("haai.model").ask(total_prompt, selection)
end

return M
