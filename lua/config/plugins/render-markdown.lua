return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown', 'md' }, -- or use event = "BufReadPre"
    keys = {
      { '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle markdown render' },
    },
    config = function()
      require('render-markdown').setup {}
    end,
  },
}
