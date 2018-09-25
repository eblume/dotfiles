alias mux "tmuxinator"

# vi mode enable
#function fish_user_key_bindings
#    # Execute this once per mode that vi bindings should be used in
#    fish_default_key_bindings -M insert
#    # Without an argument, fish_vi_key_bindings will default to
#    # resetting all bindings.
#    # The argument specifies the initial mode (insert, "default" or visual).
#    fish_vi_key_bindings insert
#end


# bobthefish theme setup
set -x VIRTUAL_ENV_DISABLE_PROMPT 0
# set -g theme_display_git yes
# set -g theme_display_git_untracked yes
#set -g theme_display_git_ahead_verbose yes
#set -g theme_git_worktree_support yes
# set -g theme_display_vagrant yes
# set -g theme_display_docker_machine no
# set -g theme_display_hg yes
# set -g theme_display_virtualenv no
# set -g theme_display_ruby no
# set -g theme_display_user yes
# set -g theme_display_vi no
# set -g theme_display_date no
#set -g theme_display_cmd_duration yes
# set -g theme_title_display_process yes
# set -g theme_title_display_path no
# set -g theme_title_use_abbreviated_path no
# set -g theme_date_format "+%a %H:%M"
# set -g theme_avoid_ambiguous_glyphs yes
# set -g theme_powerline_fonts no
#set -g theme_nerd_fonts yes  # use patched fonts (I built 'em, might as well use 'em)
# set -g theme_show_exit_status yes
# set -g default_user your_normal_user
set -g theme_color_scheme zenburn
# set -g fish_prompt_pwd_dir_length 0
# set -g theme_project_dir_length 1<Paste>


function fish_greeting
    echo "Welcome back!"
end
