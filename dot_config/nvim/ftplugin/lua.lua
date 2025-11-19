vim.treesitter.start()
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = false -- because of stylua defaults
