if vim.g.loaded_param_swap then return end
vim.g.loaded_param_swap = true

local function parse_word_start (str)
  local suffix, rest, matchlen
  str = string.match(str, '[^,]+,%s*')

  if str == nil then return nil end

  matchlen = string.len(str)

  if string.sub(str, -1, -1) == " " then
    suffix = string.sub(str, -2)
    rest = string.sub(str, 1, -3)
  elseif string.sub(str, -1, -1) == "," then
    suffix = string.sub(str, -1)
    rest = string.sub(str, 1, -2)
  else
    return nil
  end

  return suffix .. rest, matchlen
end

local function parse_comma_start (str)
  local prefix, rest, matchlen

  str =  string.match(str, ',[^%),]+')

  if str == nil then return nil end

  matchlen = string.len(str)

  if string.sub(str, 2, 2) == " " then
    prefix = string.sub(str, 1, 2)
    rest = string.sub(str, 3)
  elseif string.sub(str, 1, 1) == "," then
    prefix = string.sub(str, 1, 1)
    rest = string.sub(str, 2)
  else
    return nil
  end

  return rest .. prefix, matchlen
end
local function parse (str)
  if string.sub(str, 1, 1) == "," then
    return parse_comma_start(str)
  else
    return parse_word_start(str)
  end
end

vim.api.nvim_create_user_command("SwapParams", function()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  cursor_line = line:sub(col + 1)

  local line, matchlen = parse(cursor_line)
  if line == nil then
    vim.notify("vim-param: no match")
    return
  end

  vim.api.nvim_buf_set_text(0, row-1, col, row-1, col + matchlen, {})

  vim.fn.setreg('"', line)
end, {})

vim.keymap.set("n", "<leader>k", "<cmd>SwapParams<cr>")

-- local function assert_equals (arg1, arg2, line)
--   if arg1 ~= arg2 then
--     print(
--       "assertion failed:",
--       line, ": ",
--       string.format("|%s|", arg1),
--       "!=",
--       string.format("|%s|", arg2)
--     )
--   end
-- end
--
-- assert_equals(", &arena", parse("&arena, &left);"), debug.getinfo(1).currentline)
-- assert_equals(",&arena", parse("&arena,&left);"), debug.getinfo(1).currentline)
-- assert_equals("&left, ", parse(", &left);"), debug.getinfo(1).currentline)
-- assert_equals("&left,", parse(",&left);"), debug.getinfo(1).currentline)
-- assert_equals("&left, ", parse(", &left, bleh);"), debug.getinfo(1).currentline)
-- assert_equals("&left,", parse(",&left,bleh);"), debug.getinfo(1).currentline)
-- assert_equals(nil, parse("blehblehbleh"), debug.getinfo(1).currentline)

