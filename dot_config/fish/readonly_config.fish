# This config was adapted from what nix home-manager built for me prior to 17 Nov 2025.

# Only execute this file once per shell.
set -q __fish_config_sourced; and exit
set -g __fish_config_sourced 1

set -gx EDITOR nvim
set -gx FZF_CTRL_T_COMMAND 'fd --type file'
set -gx FZF_DEFAULT_COMMAND 'fd --type file'
set -gx FZF_DEFAULT_OPTS '-m --height 50% --border'
set -gx KUBECONFIG "$HOME/.kube/config:$HOME/.kube/eks-development.yml"
set -gx MANPAGER 'nvim +Man!'
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx ZK_DIR "$HOME"'/code/personal/zk'
set -gx ZK_PROJECT "$ZK_DIR"
set -gx fish_greeting ''
set -gx PATH '/opt/homebrew/bin/'(test -n "$PATH" && echo ':' || echo)"$PATH"

status is-login; and begin
    # Login shell initialisation

end

status is-interactive; and begin
    # Abbreviations
    abbr --add -- - 'cd -'
    abbr --add -- c cd
    abbr --add -- cdg 'cd (git rev-parse --show-toplevel)'
    abbr --add -- dash kube-dashboard
    abbr --add -- deploys 'kubectl get deployments -A'
    abbr --add -- g git
    abbr --add -- ga 'git add'
    abbr --add -- gaa 'git add -A'
    abbr --add -- gac 'git commit -am'
    abbr --add -- gb 'git branch'
    abbr --add -- gbD 'git branch -D'
    abbr --add -- gbd 'git branch -d'
    abbr --add -- gc 'git commit -m'
    abbr --add -- gca 'git commit --amend --no-edit'
    abbr --add -- gcae 'git commit --amend'
    abbr --add -- gco 'git checkout'
    abbr --add -- gcob 'git switch -c'
    abbr --add -- gcom 'git switch (git symbolic-ref refs/remotes/origin/HEAD | cut -d"/" -f4)'
    abbr --add -- gcp 'git cherry-pick'
    abbr --add -- gd 'git diff'
    abbr --add -- gdp 'git diff HEAD^'
    abbr --add -- gds 'git diff --staged'
    abbr --add -- gl 'git log --graph --decorate --oneline -20'
    abbr --add -- gll 'git log --graph --decorate --oneline'
    abbr --add -- gm 'git merge'
    abbr --add -- gp 'git push'
    abbr --add -- gpd 'git push origin -d'
    abbr --add -- gr 'git reset'
    abbr --add -- grh 'git reset --hard'
    abbr --add -- gs 'git status'
    abbr --add -- gu 'git pull'
    abbr --add -- hm rebuild-home
    abbr --add -- k kubectl
    abbr --add -- ks k9s
    abbr --add -- l 'ls -lh'
    abbr --add -- la 'ls -a'
    abbr --add -- lh 'ls -lh'
    abbr --add -- ll 'ls -alhF'
    abbr --add -- lsf 'ls -lh | fzf'
    abbr --add -- mkd 'mkdir -pv'
    abbr --add -- n nix
    abbr --add -- nixh 'man home-configuration.nix'
    abbr --add -- nixo 'man configuration.nix'
    abbr --add -- nodes 'kubectl get nodes'
    abbr --add -- nps 'nix repl '\''<nixpkgs>'\'''
    abbr --add -- nr rebuild-darwin
    abbr --add -- nro 'rebuild-darwin offline'
    abbr --add -- ns 'nix-shell -p'
    abbr --add -- nsf 'nix-shell --run fish -p'
    abbr --add -- nsr nix-shell-run
    abbr --add -- pods 'kubectl get pods -A'
    abbr --add -- s sudo
    abbr --add -- sc systemctl
    abbr --add -- scs 'systemctl status'
    abbr --add -- v nvim
    abbr --add -- vl 'nvim -c '\''normal! `0'\'''
    abbr --add -- vll 'nvim -c '\''Telescope oldfiles'\'''
    abbr --add -- yt yt-dlp
    abbr --add -- zk 'vim $ZK_PROJECT -c "cd $ZK_PROJECT"'
    abbr --add -- zkd 'vim -c "cd $ZK_PROJECT" -c '\''Obsidian dailies'\'''
    abbr --add -- zkn 'vim -c "cd $ZK_PROJECT" -c '\''Obsidian new'\'''
    abbr --add -- zkt 'vim -c "cd $ZK_PROJECT" -c '\''Obsidian today'\'''

    # Aliases
    alias icat 'wezterm imgcat'
    alias ls 'eza --group'
    alias vim nvim
    alias zf 'cd (zoxide query --list --score | fzf --height 40% --layout reverse --info inline --border --preview "eza --all --group-directories-first --header --long --no-user --no-permissions --color=always {2}" --no-sort | awk '\''{print $2}'\'')'

    # Interactive shell initialisation
    fzf --fish | source
    zoxide init fish | source
    starship init fish | source
    # source (mise activate | psub) # remove when fish is off nix; not sure why this is needed

    # some useful things
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

end
