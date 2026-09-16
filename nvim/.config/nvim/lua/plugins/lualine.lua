local function python_env()
  if vim.bo.filetype ~= "python" then
    return ""
  end

  local venv = vim.env.VIRTUAL_ENV
  local venv_name = venv and vim.fn.fnamemodify(venv, ":t") or nil

  local python = vim.g.python3_host_prog or vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
  local version = vim.fn.system(python .. " -V 2>&1"):gsub("Python ", ""):gsub("%s+", " "):gsub("^%s*", ""):gsub("%s*$", "")
  if version == "" or version:match("not found") or version:match("No such") then
    version = ""
  end

  if venv_name and version ~= "" then
    return venv_name .. " (" .. version .. ")"
  elseif venv_name then
    return venv_name
  elseif version ~= "" then
    return version
  end
  return ""
end

require('lualine').setup {
  options = {
    theme = 'tokyonight-night'
  },
  sections = {
    lualine_x = { python_env, 'encoding', 'fileformat', 'filetype' },
  }
}
