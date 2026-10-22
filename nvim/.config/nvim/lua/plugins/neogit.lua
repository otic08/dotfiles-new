require("neogit").setup({})

-- Open Neogit for the git project of the current buffer's file,
-- instead of whatever repo vim's cwd happens to be in.
vim.keymap.set("n", "<leader>gg", function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= "" and vim.fs.dirname(file)) or vim.loop.cwd()
  local toplevel = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }))
  if vim.v.shell_error == 0 then
    require("neogit").open({ cwd = toplevel })
  else
    require("neogit").open() -- fall back to cwd if not in a repo
  end
end, { desc = "Open Neogit (current git project)" })
