local M = {}

function M.ask(prompt)
  local user_prompt = "you boii: " .. prompt

  -- Temporary model response
  local response = "hello world"

  return {
    prompt = user_prompt,
    response = response,
  }
end

return M
