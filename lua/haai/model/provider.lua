local M = {}

M.__index = M

function M.new(opts)
  local self = setmetatable({}, M)

  self.model = opts.model
  self.temperature = opts.temperature or 0.2
  self.max_tokens = opts.max_tokens

  self.transport = opts.transport

  return self
end

local function build_content(prompt, selection)
  if selection and selection ~= "" then
    return prompt .. "\n\nCode:\n```text\n" .. selection .. "\n```"
  end

  return prompt
end

function M:ask(prompt, selection)
  local body = {
    model = self.model,

    messages = {
      {
        role = "user",
        content = build_content(prompt, selection),
      },
    },

    temperature = self.temperature,
  }

  if self.max_tokens then
    body.max_tokens = self.max_tokens
  end

  local response, err = self.transport:request(body)

  if not response then
    return nil, err
  end

  if response.error then
    if type(response.error) == "table" then
      return nil, response.error.message or "Provider error"
    end

    return nil, tostring(response.error)
  end

  local content =
    response.choices
    and response.choices[1]
    and response.choices[1].message
    and response.choices[1].message.content

  if not content then
    return nil, "Provider returned no response content"
  end

  return content, nil
end

return M
