local M = {}

local visual_modes = {
  v = true,
  V = true,
  ["\22"] = true,
}

function M.get()
  if not visual_modes[vim.fn.mode()] then
    return nil
  end

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  local start_row = start_pos[2]
  local start_col = start_pos[3]

  local end_row = end_pos[2]
  local end_col = end_pos[3]

  -- Handle backwards visual selections.
  if start_row > end_row
    or (start_row == end_row and start_col > end_col)
  then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_text(
    0,
    start_row - 1,
    start_col - 1,
    end_row - 1,
    end_col,
    {}
  )

  return table.concat(lines, "\n")
end

return M
