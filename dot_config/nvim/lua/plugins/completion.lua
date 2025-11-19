return {
	{ "rafamadriz/friendly-snippets" },
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"saghen/blink.cmp",
		opts = {
			keymap = {
				preset = "default", -- <C-y> to accept
				["<C-d>"] = { "show", "show_documentation", "hide_documentation" }, -- <C-space> default conflicts with hammersoon
			},
			completion = { documentation = { auto_show = true } },
		},
	},
}
