vim.g.mapleader = " "
vim.keymap.set("n", "<leader>dv", vim.cmd.Ex)
vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+yy', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+yy', { noremap = true })
vim.keymap.set({ "n", "v" }, "=", function()
    vim.lsp.buf.format()
end, { noremap = true, silent = true })
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end,
})
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float(nil, {
        focusable = true,
        scope = "cursor",
        border = "rounded"
    })
end, { desc = "Show diagnostic (focusable float)" })
