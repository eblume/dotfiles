-- Init largely copied from:
-- https://github.com/epwalsh/obsidian.nvim
require('obsidian').setup({
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
        new = "<C-x>",         -- Create a new note from telescope query
        insert_link = "<C-l>", -- Create a new link to telescope selected quote
    },
    tag_mappings = {
        tag_note = "<C-x>",   -- Add tag(s) to current note
        insert_tag = "<C-l>", -- Insert a tag at the current location
    },

    -- Recommended to sort modified/true for most recent edits first
    sort_by = "modified",
    sort_reversed = true,

    -- "current", "vsplit", "hsplit"
    -- If set other than "current", beware extra buffers from `zkd`, `zkn`, etc.
    -- (Fixable with :bdelete 0 in command but meh)
    open_notes_in = "current",

    ui = {
        enable = true,          -- refers to all the conceallevel tricks, I think
        max_file_length = 5000, -- Large files get crunchy, I think - not seen yet
        checkboxes = {
            -- I don't quite understand this array-keyed syntax, and it stumped me for having this config in obsiadian.nix
            -- (I guess that it's not an array but some sort of literal identifier, but no time to check now how to nixify)
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
            ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
    },

    follow_url_func = vim.ui.open,

    -- disable warning message, remove in 4.0
    legacy_commands = false,
})
