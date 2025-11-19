return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "RRethy/nvim-base16" },
		config = function()
			require("lualine").setup({
				theme = "base16",
				icons_enabled = true,
			})
		end,
	},
}
