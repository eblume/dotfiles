return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		tag = "v0.1.9",
		config = function()
			local telescope = require("telescope.builtin")
			vim.keymap.set("n", "<Leader>k", telescope.keymaps)
			vim.keymap.set("n", "<Leader>/", telescope.live_grep)
			vim.keymap.set("n", "<Leader>ff", telescope.find_files)
			vim.keymap.set("n", "<Leader>fp", telescope.git_files)
			vim.keymap.set("n", "<Leader>fw", telescope.grep_string)
			vim.keymap.set("n", "<Leader>b", telescope.buffers)
			vim.keymap.set("n", "<Leader>hh", telescope.help_tags)
			vim.keymap.set("n", "<Leader>fr", telescope.oldfiles)
			vim.keymap.set("n", "<Leader>cc", telescope.commands)
			vim.keymap.set("n", "<Leader>gc", telescope.git_commits)
			vim.keymap.set("n", "<Leader>gf", telescope.git_bcommits)
			vim.keymap.set("n", "<Leader>gb", telescope.git_branches)
			vim.keymap.set("n", "<Leader>gs", telescope.git_status)
			vim.keymap.set("n", "<Leader>s", telescope.current_buffer_fuzzy_find)
			vim.keymap.set("n", "<Leader>rr", telescope.resume)

			vim.keymap.set("n", "<Leader>cr", function()
				local opts = require("telescope.themes").get_ivy({
					layout_config = {
						bottom_pane = {
							height = 15,
						},
					},
				})
				telescope.command_history(opts)
			end)

			-- Zoxide
			vim.keymap.set("n", "<Leader>fz", require("telescope").extensions.zoxide.list)

			-- File browser
			require("telescope").load_extension("file_browser")
			vim.keymap.set("n", "<Leader>fa", require("telescope").extensions.file_browser.file_browser)
			vim.keymap.set("n", "<Leader>fD", function()
				local opts = {
					prompt_title = "Find Downloads",
					cwd = "~/downloads",
				}
				require("telescope").extensions.file_browser.file_browser(opts)
			end)

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
							["<C-h>"] = "which_key",
						},
					},
				},
				pickers = {
					find_files = { theme = "ivy" },
					oldfiles = { theme = "ivy" },
					buffers = { theme = "dropdown" },
				},
				extensions = {
					fzy_native = {},
					zoxide = {},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-fzy-native.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		config = function()
			require("telescope").setup({
				extensions = {
					fzy_native = {
						override_generic_sorter = true,
						override_file_sorter = true,
					},
				},
			})
			require("telescope").load_extension("fzy_native")
		end,
	},
	{ "nvim-telescope/telescope-file-browser.nvim", dependencies = "nvim-telescope/telescope.nvim" },
	{ "jvgrootveld/telescope-zoxide", dependencies = "nvim-telescope/telescope.nvim" },
}
