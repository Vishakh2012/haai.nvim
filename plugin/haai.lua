-- plugin/haai.lua

if vim.g.loaded_haai then
  return
end

vim.g.loaded_haai = true

vim.api.nvim_create_user_command("Haai", function()
  require("haai").open()
end, {})
