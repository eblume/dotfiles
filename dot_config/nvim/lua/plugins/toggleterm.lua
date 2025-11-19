return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			vim.keymap.set("t", "<A-CR>", "<C-\\><C-n>") --- Exit terminal mode

			-- Only set these keymaps for toggleterm
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "term://*toggleterm#*",
				callback = function()
					-- The only command you really need: <C-w>k, etc, jumps you around
					vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
				end,
			})

			local terminal = require("toggleterm.terminal").Terminal
			local basicterminal = terminal:new()
			function TERM_TOGGLE()
				basicterminal:toggle()
			end
			vim.keymap.set("n", "<Leader>t", TERM_TOGGLE)

			require("toggleterm").setup({
				direction = "float",
			})
		end,
	},
}
