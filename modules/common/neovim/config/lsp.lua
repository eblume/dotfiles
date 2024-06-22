vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gT", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
-- vim.keymap.set("n", "gr", telescope.lsp_references)
vim.keymap.set("n", "<Leader>R", vim.lsp.buf.rename)
vim.keymap.set("n", "]e", vim.diagnostic.goto_next)
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<Leader>de", vim.diagnostic.open_float)
vim.keymap.set("n", "<Leader>E", vim.lsp.buf.code_action)

-- Configure diagnostic floating window on hover
-- see: https://neovim.discourse.group/t/how-to-show-diagnostics-on-hover/3830/3
function OpenDiagnosticIfNoFloat()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
            return
        end
    end
    -- THIS IS FOR BUILTIN LSP
    vim.diagnostic.open_float(0, {
        scope = "cursor",
        focusable = false,
        close_events = {
            "CursorMoved",
            "CursorMovedI",
            "BufHidden",
            "InsertCharPre",
            "WinLeave",
        },
    })
end

-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    command = "lua OpenDiagnosticIfNoFloat()",
    group = "lsp_diagnostics_hold",
})
