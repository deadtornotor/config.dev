local function format_cwd()
  local cwd = vim.fn.getcwd() -- Full current working directory path
  local display_path = cwd

  if #cwd > 20 then
    display_path = '-' .. cwd:sub(-19)
  end

  return ' ' .. display_path
end


return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      sections = {
        lualine_y = {
          'progress',
          format_cwd,
        },
      },
    })
  end
}
