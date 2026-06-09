-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Window navigation keybinds
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Escape from highlight (e.g. after substitution)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- LSP keymaps
vim.keymap.set("n", "gz", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
