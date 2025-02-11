return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = '~/Sync/org/**/*',
      org_default_notes_file = '~/Sync/org/refile.org',
      org_todo_keywords = {'TODO', 'WAITING', '|', 'DONE', 'DELEGATED'},
      org_todo_keyword_faces = {
        WAITING = ':foreground blue :weight bold',
        DELEGATED = ':background #FFFFFF :slant italic :underline on',
        TODO = ':background #000000 :foreground red', -- overrides builtin color for `TODO` keyword
      }
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}
