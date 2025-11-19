return {
	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			vim.g.loaded = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				view = {
					width = 30,
					side = "left",
					number = false,
					relativenumber = false,
				},
				disable_netrw = true,
				hijack_netrw = true,
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
					ignore_list = {},
				},
				diagnostics = {
					enable = true,
					icons = {
						hint = "",
						info = "",
						warning = "",
						error = "",
					},
				},
				renderer = {
					-- Show files with changes vs. current commit
					icons = {
						glyphs = {
							git = {
								unstaged = "~",
								staged = "+",
								unmerged = "",
								renamed = "➜",
								deleted = "",
								untracked = "?",
								ignored = "◌",
							},
						},
					},
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end
					api.config.mappings.default_on_attach(bufnr)

					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
					vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
					vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
					vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
					vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
				end,
			})

			vim.keymap.set("n", "<Leader>e", ":NvimTreeFindFileToggle<CR>", { silent = true })
		end,
	},
}
