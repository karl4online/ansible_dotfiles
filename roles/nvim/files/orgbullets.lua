return {
  "akinsho/org-bullets.nvim",
  config = function()
    require("org-bullets").setup({
      concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
      symbols = {
        -- list symbol
        list = "•",
        -- -- headlines can be a list
        -- headlines = { "◉", "○", "✸", "✿" },
        -- -- or a function that receives the defaults and returns a list
        -- headlines = function(default_list)
        --   table.insert(default_list, "♥")
        --   return default_list
        -- end,
        -- or false to disable the symbol. Works for all symbols
        -- headlines = false,
        -- or a table of tables that provide a name
        -- and (optional) highlight group for each headline level
        headlines = {
          { "◉", "MyBulletL1" },
          { "○", "MyBulletL2" },
          { "✸", "MyBulletL3" },
          { "✿", "MyBulletL4" },
        },
        checkboxes = {
          half = { "", "@org.checkbox.halfchecked" },
          done = { "✓", "@org.keyword.done" },
          todo = { "˟", "@org.keyword.todo" },
        },
      },
    })
  end,
}
