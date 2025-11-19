return {
	{
		"godlygeek/tabular",
		config = function()
			vim.keymap.set("", "<Leader>ta", ":Tabularize /")
			vim.keymap.set("", "<Leader>t#", ":Tabularize /#<CR>")
			vim.keymap.set("", "<Leader>tl", ":Tabularize /---<CR>")
		end,
	},
}
