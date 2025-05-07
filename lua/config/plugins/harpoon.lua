return {
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon').setup {

        vim.keymap.set('n', '<CS-h>', function()
          require('harpoon.mark').set_current_at(1)
          print 'harpoon mark for h set'
        end, { desc = 'add [h] harpoon mark (1)' }),
        vim.keymap.set('n', '<C-h>', function()
          require('harpoon.ui').nav_file(1)
        end, { desc = 'open [h] harpoon mark (1)' }),
        vim.keymap.set('n', '<CS-j>', function()
          require('harpoon.mark').set_current_at(2)
          print 'harpoon mark for j set'
        end, { desc = 'add [j] harpoon mark (2)' }),
        vim.keymap.set('n', '<C-j>', function()
          require('harpoon.ui').nav_file(2)
        end, { desc = 'open [j] harpoon mark (2)' }),
        vim.keymap.set('n', '<CS-k>', function()
          require('harpoon.mark').set_current_at(3)
          print 'harpoon mark for k set'
        end, { desc = 'add [k] harpoon mark (3)' }),
        vim.keymap.set('n', '<C-k>', function()
          require('harpoon.ui').nav_file(3)
        end, { desc = 'open [k] harpoon mark (3)' }),
        vim.keymap.set('n', '<CS-l>', function()
          require('harpoon.mark').set_current_at(4)
          print 'harpoon mark for l set'
        end, { desc = 'add [l] harpoon mark (4)' }),
        vim.keymap.set('n', '<C-l>', function()
          require('harpoon.ui').nav_file(4)
        end, { desc = 'open [l] harpoon mark (4)' }),
        vim.keymap.set('n', '<leader>hu', require('harpoon.ui').toggle_quick_menu, { desc = '[h]arpoon open [u]i' }),
      }
    end,
  },
}
