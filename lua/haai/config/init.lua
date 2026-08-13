local M = {}

function M.ask(prompt, selection)
  -- This is where your actual AI configuration will eventually go.
  --
  -- `prompt`     = what the user typed
  -- `selection`  = visually selected code, if any

  return {
    prompt = prompt,
    selection = selection,
    response = "hello world",
  }
end

return M
