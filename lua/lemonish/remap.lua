vim.g.mapleader = " "
vim.keymap.set("n", "<leader>dv", vim.cmd.Ex)
vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+yy', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+yy', { noremap = true })
