return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'nightfly',
      },
      sections = {
        lualine_x = {
          'rest',
          'encoding',
          'fileformat',
          'filetype',
        },
      },
    }
  end,
}
