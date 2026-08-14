local M = {}

M.__index = M

function M.new(opts)
  local self = setmetatable({}, M)

  self.endpoint = opts.endpoint
  self.api_key = opts.api_key

  return self
end

function M:request(body)
  local args = {
    "curl",
    "-sS",
    "-X",
    "POST",
    self.endpoint,
    "-H",
    "Content-Type: application/json",
    "-d",
    vim.json.encode(body),
  }

  if self.api_key then
    table.insert(args, "-H")
    table.insert(args, "Authorization: Bearer " .. self.api_key)
  end

  local result = vim.system(args, {
    text = true,
  }):wait()

  if result.code ~= 0 then
    return nil, result.stderr
  end

  local ok, response = pcall(vim.json.decode, result.stdout)

  if not ok then
    return nil, "Invalid JSON response: " .. result.stdout
  end

  return response, nil
end

return M
