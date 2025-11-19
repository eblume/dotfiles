return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- see https://github.com/folke/which-key.nvim
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
