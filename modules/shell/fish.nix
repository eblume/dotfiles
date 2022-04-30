{ pkgs, identity, ... }: {

  users.users.${identity.user}.shell = pkgs.fish;

  home-manager.users.${identity.user} = {

    home.packages = with pkgs; [ exa fd bat ripgrep ];

    programs.fish = {
      enable = true;
      functions = {
        commandline-git-commits = {
          description = "Insert commit into commandline";
          body = builtins.readFile
            ../../fish.configlink/functions/commandline-git-commits.fish;
        };
        copy = {
          description = "Copy file contents into clipboard";
          body = "cat $argv | pbcopy"; # Need to fix for non-macOS
        };
        edit = {
          description = "Open a file in Vim";
          body = builtins.readFile ../../fish.configlink/functions/edit.fish;
        };
        envs = {
          description = "Evaluate a bash-like environment variables file";
          body = ''set -gx (cat $argv | tr "=" " " | string split ' ')'';
        };
        fcd = {
          description = "Jump to directory";
          argumentNames = "directory";
          body = builtins.readFile ../../fish.configlink/functions/fcd.fish;
        };
        fish_user_key_bindings = {
          body = builtins.readFile
            ../../fish.configlink/functions/fish_user_key_bindings.fish;
        };
        ip = {
          body = builtins.readFile ../../fish.configlink/functions/ip.fish;
        };
        json = {
          description = "Tidy up JSON using jq";
          body = "pbpaste | jq '.' | pbcopy"; # Need to fix for non-macOS
        };
        ls = { body = "exa $argv"; };
        note = {
          description = "Edit or create a note";
          argumentNames = "filename";
          body = builtins.readFile ../../fish.configlink/functions/note.fish;
        };
        projects = {
          description = "Jump to a project";
          body = ''
            set projdir (ls $PROJ | fzf)
            and cd $PROJ/$projdir
            and commandline -f execute
          '';
        };
        recent = {
          description = "Open a recent file in Vim";
          body = builtins.readFile ../../fish.configlink/functions/recent.fish;
        };
        syncnotes = {
          description = "Full git commit on notes";
          body =
            builtins.readFile ../../fish.configlink/functions/syncnotes.fish;
        };
      };
      interactiveShellInit = ''
        bind yy fish_clipboard_copy
        bind Y fish_clipboard_copy
        bind -M visual y fish_clipboard_copy
        bind p fish_clipboard_paste
        set -g fish_vi_force_cursor
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_visual block
        set -g fish_cursor_replace_one underscore
      '';
      loginShellInit = "";
      shellAliases = { };
      shellAbbrs = {

        # Directory aliases
        l = "ls";
        lh = "ls -lh";
        ll = "ls -alhF";
        la = "ls -a";
        lf = "ls -lh | fzf";
        c = "cd";
        "-" = "cd -";
        mkd = "mkdir -pv";

        # System
        s = "sudo";
        sc = "systemctl";
        scs = "systemctl status";
        reb = "nixos-rebuild switch -I nixos-config=${
            builtins.toString ../../nixos/.
          }/configuration.nix";

        # Tmux
        ta = "tmux attach-session";
        tan = "tmux attach-session -t noah";
        tnn = "tmux new-session -s noah";

        # Vim
        v = "vim";
        vl = "vim -c 'normal! `0'";

        # Notes
        sn = "syncnotes";

        # CLI Tools
        h = "http -Fh --all"; # Curl site for headers
        m = "make"; # For makefiles

        # Fun CLI Tools
        weather = "curl wttr.in/$WEATHER_CITY";
        moon = "curl wttr.in/Moon";

        # Cheat Sheets
        ssl =
          "openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr";
        fingerprint = "ssh-keyscan myhost.com | ssh-keygen -lf -";
        publickey = "ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub";
        forloop = "for i in (seq 1 100)";

        # Docker
        dc = "$DOTS/bin/docker_cleanup";
        dr = "docker run --rm -it";
        db = "docker build . -t";

        # Terraform
        te = "terraform";

        # Kubernetes
        k = "kubectl";
        pods = "kubectl get pods -A";
        nodes = "kubectl get nodes";
        deploys = "kubectl get deployments -A";
        dash = "kube-dashboard";
        ks = "k9s";

        # Python
        py = "python";
        po = "poetry";
        pr = "poetry run python";

        # Rust
        ca = "cargo";

      };
      shellInit = "";
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    home.sessionVariables = let fzfCommand = "fd --type file";
    in {
      fish_greeting = "";
      FZF_DEFAULT_COMMAND = fzfCommand;
      FZF_CTRL_T_COMMAND = fzfCommand;
      FZF_DEFAULT_OPTS = "-m --height 50% --border";
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    xdg.configFile = {
      "starship.toml".source = ../../starship/starship.toml.configlink;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = { whitelist = { prefix = [ "${builtins.toString ../.}/" ]; }; };
    };
  };
}
