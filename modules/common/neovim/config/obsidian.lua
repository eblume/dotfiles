-- Obsidian.nvim has features that require conceallevel > 0
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.o.conceallevel = 1
  end,
})

-- Init largely copied from:
-- https://github.com/epwalsh/obsidian.nvim
require('obsidian').setup({
  -- TODO: Do something smarter with workspaces.
  -- For instance, path can be a lua function which can, for instance, target
  -- an environment variable - set by mole or envrc/devenv?
  workspaces = {
    {
      name = "zk",
      path = "~/code/personal/zk",
    },
  },

  -- This *should* be synced via the vault's sync community plugins setting, but if not:
  --  Enabled:
  --     * Use UID instead of file paths
  --     * Add filepath parameter
  -- This is intended to make hyperlinks work across multiple vaults, so that
  -- I can make portable cross-project links. Using a UID in the URI means
  -- that file move operations are nondestructive. Tbe tradeoff is that every
  -- link will be pretty long, but conceallevel=1 helps with that.
  use_advanced_uri = true,

  -- NOTE: :ObsidianOpen is currently broken due to nix-darwin's packaging of Obsidian.app
  -- There was a PR open that got closed without merging that would have fixed this.
  -- I've left a comment here: https://github.com/epwalsh/obsidian.nvim/issues/304

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

  -- "current", "vsplit", "hsplit" open_notes_in = "vsplit",

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
})
