local M = {}

local Job = require('plenary.job')

M.setup = function(opts)
  M.opts = opts
end

local id = function()
  return tostring({}):sub(10)
end

local win_opts = {
  relative = 'cursor', -- win, editor, cursor
  style = 'minimal',   -- minimal, border
  bufpos = { 0, 0 },
  width = 34,
  height = 7,
  row = -7,
  border = 'rounded', -- single, double, shadow, none, rounded
}

M.pick = function()
  local pipe = '/tmp/loriini.' .. id()
  local colorizer_installed, colorizer = pcall(require, 'colorizer')
  os.execute('mkfifo ' .. pipe)
  local BUF = vim.api.nvim_get_current_buf()

  local LISTEN = Job:new({
    command = '/bin/dd',
    args = { 'if=' .. pipe, 'bs=7' },
    interactive = false,
    on_stderr = function(_, data, _)
      print(data)
    end,
    on_exit = function(job, _, _)
      vim.schedule(function()
        job:shutdown()
        os.execute('rm -f ' .. pipe)
      end)
    end,
    on_stdout = function(_, data, _)
      vim.schedule(function()
        vim.api.nvim_buf_call(BUF, function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local line = vim.api.nvim_get_current_line()
          local color_pattern = "#%x+"
          local start_pos, end_pos = line:find(color_pattern, 0, false)
          if (not start_pos or not end_pos) then return end
          local color = "#" .. data
          vim.api.nvim_buf_set_text(BUF, cursor[1] - 1, start_pos - 1, cursor[1] - 1, end_pos, { color })
          if colorizer_installed then colorizer.attach_to_buffer(BUF) end
        end)
      end)
    end,
  }):start()

  local loriini = ''
  local line = vim.api.nvim_get_current_line()
  local color_pattern = "#%x+"
  local start_pos, end_pos = line:find(color_pattern, 0, false)
  if (start_pos and end_pos) then
    loriini = M.opts.bin .. " -c " .. line:sub(start_pos + 1, end_pos) .. " -p " .. pipe
  else
    loriini = M.opts.bin .. " -p " .. pipe
  end

  local BUFNR = vim.api.nvim_create_buf(false, true)
  local WINNR = vim.api.nvim_open_win(BUFNR, true, win_opts)
  vim.api.nvim_feedkeys("i", "n", false)

  vim.fn.termopen(loriini, {
    on_exit = function(_, _, _)
      vim.api.nvim_win_close(WINNR, true)
    end,
  })
end

return M
