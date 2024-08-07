-- ===========================================================================
-- Settings
-- ===========================================================================

vim.filetype.add({
    pattern = {
        [".*%.tfvars"] = "terraform",
        [".*%.tf"] = "terraform",
        [".*%.rasi"] = "rasi",
    },
})

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
    pattern = "markdown",
    command = "TableModeEnable",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.o.shiftwidth = 2
        vim.o.softtabstop = 2
    end,
})
