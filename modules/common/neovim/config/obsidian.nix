# Obsidian in neovim via Obsidian.nvim
# https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file
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

    # This *should* be synced via the vault's sync community plugins setting, but if not:
    #   Enabled:
    #     * Use UID instead of file paths
    #     * Add filepath parameter
    # This is intended to make hyperlinks work across multiple vaults, so that
    # I can make portable cross-project links. Using a UID in the URI means
    # that file move operations are nondestructive. Tbe tradeoff is that every
    # link will be pretty long, but conceallevel=1 helps with that.
    use_advanced_uri = true;

    # NOTE: :ObsidianOpen is currently broken due to nix-darwin's packaging of Obsidian.app
    # There was a PR open that got closed without merging that would have fixed this.
    # I've left a comment here: https://github.com/epwalsh/obsidian.nvim/issues/304

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
