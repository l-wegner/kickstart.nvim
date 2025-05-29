return {
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>rr', '<cmd>Rest run<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>rl', '<cmd>Rest last<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>re', '<cmd>Telescope rest select_env<CR>', { noremap = true, silent = true })
    end,
  }, -- Example keybindings for rest.nvim
}
