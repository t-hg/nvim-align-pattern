vim = vim

local function process_selected_lines(opts)
  local pattern = opts.args
  local _, line_start, _ = unpack(vim.fn.getpos("'<"))
  local _, line_end, _ = unpack(vim.fn.getpos("'>"))
  local findings = {}
  for line_nr = line_start, line_end, 1 do
    local line = vim.fn.getline(line_nr)
    local column_start, _ = string.find(line, pattern)
    if column_start ~= nil then
      findings[line_nr] = column_start
    end
  end
  local max_column = 0
  for _, column in pairs(findings) do
    if column > max_column then
      max_column = column
    end
  end
  for line_nr, column in pairs(findings) do
    local format = string.format("%%%ds", max_column - column)
    local padding = string.format(format, "")
    vim.api.nvim_buf_set_text(0, line_nr - 1, column - 1, line_nr - 1, column - 1, { padding })
  end
end

local function setup()
  vim.api.nvim_create_user_command(
    "AlignPattern",
    process_selected_lines,
    { nargs = 1, desc = "Aligns selected lines based on given pattern", range = true }
  )
end

return {
  setup = setup,
}
