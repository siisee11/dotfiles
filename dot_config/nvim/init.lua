vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true

-- Split navigation shortcuts.
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Window: down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Window: up" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Window: right" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Window: left" })

-- Quick close for terminal windows.
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>:q<CR>", { desc = "Terminal: close window" })
vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<C-a>", "<nop>")
vim.keymap.set("n", "<C-x>", "<nop>")

require("config.lazy")

