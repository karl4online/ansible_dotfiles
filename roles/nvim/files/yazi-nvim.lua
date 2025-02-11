---@type LazySpec
return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>_',
      mode = { 'n', 'v' },
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at current file',
    },
    {
      '<leader>-',
      mode = { 'n', 'v' },
      '<cmd>Yazi cwd<cr>',
      desc = "Open Yazi in working directory",
    },
  },
  ---@type YaziConfig
  opts = {
    open_for_directories = true,
    keymaps = {
      show_help = '<f1>',
    },
  },
}
