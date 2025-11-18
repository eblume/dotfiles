-- ===========================================================================
-- Autocommands
-- ===========================================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "mail",
    callback = function()
        vim.o.wrapmargin = 79 -- Wrap text automatically
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown,text",
    callback = function()
        vim.o.spell = true -- spell check enabled
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.o.shiftwidth = 2
        vim.o.softtabstop = 2
    end,
})

-- Obsidian.nvim has features that require conceallevel > 0
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.o.conceallevel = 1
    end,
})

