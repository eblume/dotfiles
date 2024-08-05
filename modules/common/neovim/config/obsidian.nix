# Obsidian in neovim via Obsidian.nvim
# https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file

# TODO this whole package should only be enabled if options.obsidian, but I'm too lazy to test right now

{ pkgs, ... }:
{
  plugins = [
    pkgs.vimPlugins.obsidian-nvim
    pkgs.vimPlugins.nvim-treesitter
  ];

  lua = ''
    ${builtins.readFile ./obsidian.lua}
  '';

  setup.obsidian = {
    # TODO: Do something smarter with workspaces.
    # For instance, path can be a lua function which can, for instance, target
    # an environment variable - set by mole or envrc/devenv?
    workspaces = [
      {
        name = "zk";
        path = "~/code/personal/zk";
      }
    ];

    # NOTE: :ObsidianOpen is currently broken due to nix-darwin's packaging of Obsidian.app
    # There was a PR open that got closed without merging that would have fixed this.
    # I've left a comment here: https://github.com/epwalsh/obsidian.nvim/issues/304
    # For now I'm just making do without but I think I could package this specific PR's commit too?
    # Or patch it; it's a small change.
    # Oh - or I could manually link the Application? hmmm

    picker = {
      name = "telescope.nvim";
      new = "<C-x>"; # Create a new note from telescope query
      insert_link = "<C-l>"; # Create a new link to telescope selected quote
    };
    tag_mappings = {
      tag_note = "<C-x>"; # Add tag(s) to current note
      insert_tag = "<C-l>"; # Insert a tag at the current location
    };

    # Recommended to sort modified/true for most recent edits first
    sort_by = "modified";
    sort_reversed = true;

  };
}
