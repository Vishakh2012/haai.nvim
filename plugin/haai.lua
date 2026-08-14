if vim.g.loaded_haai then
  return
end

vim.g.loaded_haai = true

local haai = require("haai")

vim.api.nvim_create_user_command("Haai", function()
  haai.open()
end, {
  desc = "Open Haai",
})

vim.keymap.set({ "n", "v" }, "<leader>h", function()
  haai.open()
end, {
  desc = "Open Haai",
})
