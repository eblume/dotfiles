return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- use latest release, not latest commit
		opts = {
			workspaces = {
				-- Attempt to use $ZK_PROJECT dynamically
				{
					name = "zk-project",
					path = function()
						return assert(os.getenv("ZK_PROJECT"))
					end,
					-- strict = true, -- might be needed if links are broken, unclear
					-- (Also there is an overrides = {...} for proj-specific settings, hmm)
				},
				-- Default workspace for my primary 'zk' knowledge base, matches last:
				{
					name = "zk",
					path = "~/code/personal/zk",
				},
			},

			picker = {
				name = "telescope.nvim",
				note_mappings = {
					new = "<C-x>", -- Create a new note from telescope query
					insert_link = "<C-l>", -- Create a new link to telescope selected quote
				},
				tag_mappings = {
					tag_note = "<C-x>", -- Add tag(s) to current note
					insert_tag = "<C-l>", -- Insert a tag at the current location
				},
			},

			-- Recommended to sort modified/true for most recent edits first
			sort = {
				sort_by = "modified",
				sort_reversed = true,
			},

			-- "current", "vsplit", "hsplit"
			-- If set other than "current", beware extra buffers from `zkd`, `zkn`, etc.
			-- (Fixable with :bdelete 0 in command but meh)
			open_notes_in = "current",

			ui = {
				-- Note, devs have said they are trying to move away from ui module entirely
				enable = true, -- refers to all the conceallevel tricks, I think
				max_file_length = 5000, -- Large files get crunchy, I think - not seen yet
			},

			checkbox = {
				enabled = true,
				order = { " ", "x", ">", "~", "!" },
			},

			completion = {
				blink = true,
			},

			-- disable warning message, remove in 4.0
			legacy_commands = false,
		},
	},
}
