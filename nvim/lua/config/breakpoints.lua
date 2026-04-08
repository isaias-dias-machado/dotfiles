local override_line = os.getenv("NVIM_BREAKPOINT_LINE")
local has_vim = type(vim) == "table" and type(vim.api) == "table"

local function get_line ()
  if override_line and override_line ~= "" then
    return override_line
  end
  if has_vim then
    local filename = vim.api.nvim_buf_get_name(0)
    if filename == "" then
      error("current buffer has no name; cannot set a breakpoint")
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    return string.format("%s:%d", filename, row)
  end
  return "main.c:7"
end

function toggle_line (text, line)
  text, count = string.gsub(text, line, "")
  if count == 0 then
    return text .. line
  end
  return text
end

-- function write_line_to_file (filename, linenum)
--   io.input
-- end

local function toggle_breakpoint_file (filename)
  filename = filename or arg and arg[1] or "_breakpoints"
  local file = io.open(filename, "r")
  local contents = ""
  if file then
    contents = file:read("*all")
    file:close()
  end

  local break_line = "break " .. get_line() .. "\n"
  contents = toggle_line(contents, break_line)

  file = assert(io.open(filename, "w"))
  file:write("set breakpoint pending on\n")
  file:write(contents)
  file:close()
end

if has_vim and vim.api.nvim_create_user_command then
  vim.api.nvim_create_user_command("ToggleBreakpoint", function(opts)
    toggle_breakpoint_file(opts.args ~= "" and opts.args or nil)
    vim.notify("Breakpoint set")
  end, { nargs = "?", desc = "Toggle a breakpoint at the current cursor line" })

  vim.keymap.set("n", "<leader>b", "<cmd>ToggleBreakpoint<cr>")
else
  toggle_breakpoint_file()
end
