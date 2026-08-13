local M = {}

local state = {
  buf = nil,
  win = nil,
}

local function get_small_size()
  return {
    width = math.floor(vim.o.columns * 0.45),
    height = 3,
  }
end

local function get_large_size()
  return {
    width = math.floor(vim.o.columns * 0.75),
    height = math.floor(vim.o.lines * 0.65),
  }
end

local function get_position(width, height)
  return {
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  }
end

local function resize(width, height)
  local position = get_position(width, height)

  vim.api.nvim_win_set_config(state.win, {
    relative = "editor",
    width = width,
    height = height,
    row = position.row,
    col = position.col,
    style = "minimal",
    border = "rounded",
  })
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  state.win = nil
  state.buf = nil
end

local function submit()
  local lines = vim.api.nvim_buf_get_lines(
    state.buf,
    0,
    -1,
    false
  )

  local prompt = table.concat(lines, " ")
  prompt = vim.trim(prompt)

  if prompt == "" then
    return
  end

  vim.cmd("stopinsert")

  local config = require("haai.config")
  local result = config.ask(prompt)

  local size = get_large_size()

  resize(size.width, size.height)

  vim.bo[state.buf].modifiable = true

  vim.api.nvim_buf_set_lines(
    state.buf,
    0,
    -1,
    false,
    {
      result.prompt,
      "",
      "haai:",
      "",
      result.response,
    }
  )

  vim.bo[state.buf].modifiable = false

  vim.keymap.set("n", "q", close, {
    buffer = state.buf,
    silent = true,
  })

  vim.keymap.set("n", "<Esc>", close, {
    buffer = state.buf,
    silent = true,
  })
end

function M.open()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    return
  end

  local size = get_small_size()
  local position = get_position(size.width, size.height)

  state.buf = vim.api.nvim_create_buf(false, true)

  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].bufhidden = "wipe"
  vim.bo[state.buf].swapfile = false

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = size.width,
    height = size.height,
    row = position.row,
    col = position.col,
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_buf_set_lines(
    state.buf,
    0,
    -1,
    false,
    { "" }
  )

  vim.keymap.set("i", "<CR>", submit, {
    buffer = state.buf,
    silent = true,
  })

  vim.keymap.set({ "n", "i" }, "<Esc>", close, {
    buffer = state.buf,
    silent = true,
  })

  vim.cmd("startinsert")
end

return M
