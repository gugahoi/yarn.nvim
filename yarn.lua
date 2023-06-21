local M = {}

P = function(v)
  print(vim.inspect(v))
  return v
end

local function is_empty(str)
  return str == nil or str == ""
end

local function find_package_json()
  local root_dir = vim.fn.findfile("package.json", ".;")
  if is_empty(root_dir) then
    error("cannot find package.json")
  end
  return root_dir
end

local function get_scripts(filepath)
  local json = vim.fn.json_decode(vim.fn.readfile(filepath))
  if json == nil then
    error("empty file not supported")
  end
  local names = {}
  for key, _ in pairs(json.scripts) do
    table.insert(names, key)
  end
  return names
end

M.run_cmd = function()
  local cmd_name = vim.api.nvim_get_current_line()
  vim.api.nvim_buf_delete(0, { force = true })

  -- local bufnr = vim.api.nvim_create_buf(false, true)
  -- local termid = vim.api.nvim_open_term(bufnr, {})
  -- vim.api.nvim_chan_send(termid, "yarn " .. cmd_name .. "\n")

  local job = require("plenary.job")
  job:new({
    command = "yarn",
    args = { cmd_name },
    on_exit = function(j, return_val)
      P(return_val)
      P(j:result())
    end,
  }):sync()
end

-- Define a function to create a popup
local function create_popup(lines)
  local width = 40
  local height = #lines
  local row = vim.o.lines / 2 - height / 2
  local col = vim.o.columns / 2 - width / 2

  -- Create the floating window
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "NPM Scripts",
  }) -- Open the floating window

  -- Set the content of the popup
  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

  -- Close the popup when pressing any key
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":q<CR>", { silent = true })

  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<CR>",
    ":lua require('yarn').run_cmd()<CR>",
    { silent = true, noremap = true }
  )

  -- Set the autocmd to close the popup when leaving insert mode
  vim.cmd([[autocmd InsertLeave <buffer> :q]])

  return bufnr, winnr
end

M.go = function()
  local filepath = find_package_json()
  local scripts = get_scripts(filepath)
  create_popup(scripts)
end

-- M.go()

return M
