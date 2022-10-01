-- Tmux
--
local opts = { noremap=true, silent=true }
local tmux = require 'tmux'
vim.keymap.set("n", "<C-h>", tmux.move_left, opts)
vim.keymap.set("n", "<C-j>", tmux.move_down, opts)
vim.keymap.set("n", "<C-k>", tmux.move_up, opts)
vim.keymap.set("n", "<C-l>", tmux.move_right, opts)
