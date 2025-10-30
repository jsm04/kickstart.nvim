return {
  {
    'andymass/vim-matchup',
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },

  {
    'voldikss/vim-floaterm',
    config = function()
      vim.g.floaterm_height = 0.68
      vim.g.floaterm_width = 0.68
    end,
  },
}
