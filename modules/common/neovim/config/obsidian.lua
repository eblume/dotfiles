-- Obsidian.nvim has features that require conceallevel > 0
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.o.conceallevel = 1
    end,
})
