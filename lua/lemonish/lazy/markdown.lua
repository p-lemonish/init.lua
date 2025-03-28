return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_auto_start = 0         -- set to 1 if you want it to auto-launch
        vim.g.mkdp_auto_close = 1         -- auto-close preview when you leave the buffer
        vim.g.mkdp_refresh_slow = 0       -- live preview without delay
        vim.g.mkdp_command_for_global = 0 -- preview only when in markdown buffers
        vim.g.mkdp_open_to_the_world = 0  -- only local access
        vim.g.mkdp_browser = ""           -- use system default browser
        vim.g.mkdp_theme = "dark"         -- or "light"
    end,
    ft = { "markdown" },

    -- After installing markdown-preview, with higher version of node you need to:
    -- cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app
    -- npm install tslib
}
