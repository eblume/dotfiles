{
  config,
  pkgs,
  lib,
  ...
}:
{
  users.users.${config.user}.shell = pkgs.fish;
  programs.fish.enable = true; # I don't see why this is needed twice.

  home-manager.users.${config.user} = {

    # Packages used in abbreviations and aliases
    home.packages = with pkgs; [ curl ];

    programs.fish = {
      enable = true;
      shellAliases = {

        # Version of bash which works much better on the terminal
        bash = "${pkgs.bashInteractive}/bin/bash";

        # Use eza (exa) instead of ls for fancier output
        ls = "${pkgs.eza}/bin/eza --group";

        # Move files to XDG trash on the commandline
        trash = lib.mkIf pkgs.stdenv.isLinux "${pkgs.trash-cli}/bin/trash-put";

        # Zoxide commands
        # z -- zoxide default, 'smart cd'
        # zi -- zoxide default, 'interactive cd'
        # zf -- 'interactive smart cd with fuzzy matching and preview'
        zf = "cd (${pkgs.zoxide}/bin/zoxide query --list --score | ${pkgs.fzf}/bin/fzf --height 40% --layout reverse --info inline --border --preview \"${pkgs.eza}/bin/eza --all --group-directories-first --header --long --no-user --no-permissions --color=always {2}\" --no-sort | awk '{print $2}')";
        # via gh:AdrianArtiles https://github.com/ajeetdsouza/zoxide/issues/34#issuecomment-2099442403
      };
      functions = {
        envs = {
          description = "Evaluate a bash-like environment variables file";
          body = ''set -gx (cat $argv | tr "=" " " | string split ' ')'';
        };
        fcd = {
          description = "Jump to directory";
          argumentNames = "directory";
          body = builtins.readFile ./functions/fcd.fish;
        };
        ip = {
          body = builtins.readFile ./functions/ip.fish;
        };
        search-and-edit = {
          description = "Search and open the relevant file in Vim";
          body = builtins.readFile ./functions/search-and-edit.fish;
        };
        workon = {
          description = "Set $ZK_PROJECT='payrix' and open or create a note for the ticket.";
          argumentNames = "ticket";
          body = builtins.readFile ./functions/workon.fish;
        };
        oncall = {
          description = "Set $ZK_PROJECT='payrix' and open or create a note for the ticket.";
          argumentNames = "pageid";
          body = builtins.readFile ./functions/oncall.fish;
        };
      };
      interactiveShellInit = ''
        fish_vi_key_bindings
        bind yy fish_clipboard_copy
        bind Y fish_clipboard_copy
        bind -M visual y fish_clipboard_copy
        bind -M default p fish_clipboard_paste
        set -g fish_vi_force_cursor
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_visual block
        set -g fish_cursor_replace_one underscore

        # pipx install location:
        fish_add_path ~/.local/bin

        # csharp-ls fix for manually-installed csharp-ls via dotnet via mise (see lsp.nix):
        fish_add_path ~/.dotnet/tools/
        set -gx DOTNET_ROOT (dirname (which dotnet))
      '';
      loginShellInit = "";
      shellAbbrs = {

        # Directory aliases
        l = "ls -lh";
        lh = "ls -lh";
        ll = "ls -alhF";
        la = "ls -a";
        c = "cd";
        "-" = "cd -";
        mkd = "mkdir -pv";

        # System
        s = "sudo";
        sc = "systemctl";
        scs = "systemctl status";

        # Vim (overwritten by Neovim)
        v = "vim";
        vl = "vim -c 'normal! `0'";

        # [[Obsidian.nvim]] commands
        zk = "vim $ZK_PROJECT -c \"cd $ZK_PROJECT\"";
        zkt = "vim -c \"cd $ZK_PROJECT\" -c 'ObsidianToday'";
        zkn = "vim -c \"cd $ZK_PROJECT\" -c 'ObsidianNew'";
        zkd = "vim -c \"cd $ZK_PROJECT\" -c 'ObsidianDailies'";
      };
      shellInit = "";
    };

    home.sessionVariables = {
      ZK_DIR = "$HOME/code/personal/zk"; # See [[Obsidian.nvim]], aka 1722897441-MWFE.md
      ZK_PROJECT = "$ZK_DIR";
      fish_greeting = "";
    };

    programs.starship.enableFishIntegration = true;
    programs.zoxide.enableFishIntegration = true;
    programs.fzf.enableFishIntegration = true;
  };
}
