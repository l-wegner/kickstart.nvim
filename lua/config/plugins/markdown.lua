return {
  {
    '3rd/image.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('image').setup {
        backend = 'ueberzug',
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { 'markdown', 'vim.md' }, -- Add your md variants
          },
          neorg = {
            enabled = true,
            filetypes = { 'norg' },
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = true, -- Clears images when windows overlap
        window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
      }
    end,
  },
}
