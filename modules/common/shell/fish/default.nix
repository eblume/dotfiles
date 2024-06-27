{
  config,
  pkgs,
  lib,
  ...
}:
{
  users.users.${config.user}.shell = pkgs.fish;
  programs.fish.enable = true; # Needed for LightDM to remember username

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
      };
      functions = {
        copy = {
          description = "Copy file contents into clipboard";
          body = "cat $argv | pbcopy"; # Need to fix for non-macOS
        };
        edit = {
          description = "Open a file in Vim";
          body = builtins.readFile ./functions/edit.fish;
        };
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
        recent = {
          description = "Open a recent file in Vim";
          body = builtins.readFile ./functions/recent.fish;
        };
        search-and-edit = {
          description = "Search and open the relevant file in Vim";
          body = builtins.readFile ./functions/search-and-edit.fish;
        };
        payrix-vpn = {
          description = "Start the payrix openvpn client using sudo";
          body = builtins.readFile ./functions/vpn.fish;
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
        # HACK: see 1password.nix, shouldn't need this
        if test -e ${config.ssh-agent-socket}
          set -g SSH_AUTH_SOCK ${config.ssh-agent-socket}
        end
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
        m = "make";
        t = "trash";

        # Vim (overwritten by Neovim)
        v = "vim";
        vl = "vim -c 'normal! `0'";

        # Docker
        dc = "$DOTS/bin/docker_cleanup";
        dr = "docker run --rm -it";
        db = "docker build . -t";
      };
      shellInit = "";
    };

    home.sessionVariables.fish_greeting = "";

    programs.starship.enableFishIntegration = true;
    programs.zoxide.enableFishIntegration = true;
    programs.fzf.enableFishIntegration = true;
  };
}
