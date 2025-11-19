vim.treesitter.start()
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.o.shiftwidth  = 2
vim.o.softtabstop = 2
