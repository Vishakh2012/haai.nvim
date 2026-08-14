local M = {}

local provider

local function create_transport(opts)
  local transport_type = opts.transport.type

  if transport_type == "http" then
    return require("haai.model.transports.http").new(opts.transport)
  end

  error("Unknown transport: " .. tostring(transport_type))
end

function M.setup(opts)
  local Provider = require("haai.model.provider")

  local transport = create_transport(opts)

  provider = Provider.new({
    model = opts.model,
    temperature = opts.temperature,
    max_tokens = opts.max_tokens,
    transport = transport,
  })
end

function M.ask(prompt, selection)
  if not provider then
    return nil, "HAAI model has not been configured"
  end

  return provider:ask(prompt, selection)
end

return M
