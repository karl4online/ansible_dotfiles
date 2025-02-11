-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Move selected lines up or down
map('v', 'J', ":m '>+1<CR>gv=gv", opts) -- move selected lines down
map('v', 'K', ":m '<-2<CR>gv=gv", opts) -- move selected lines up

map('i', 'jk', '<Esc>', opts)
map('i', 'kj', '<Esc>', opts)
map('i', 'qw', '<Esc>', opts)
map('i', 'wq', '<Esc>', opts)

-- Buffers
-- map('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
-- map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })

-- Stuff for convenience
map('n', 'o', 'o<esc>', opts)
map('n', 'O', 'O<esc>', opts)
map('n', '<Return>', 'o<esc>', opts)
map('n', '<Backspace>', 'ddk', opts)

-- Move to start/end of line
map("n", "<S-h>", "^", { desc = "First character on current line" })
map("n", "<S-l>", "g_", { desc = "Last non-blank character on current line" })
