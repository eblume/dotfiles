#compdef zellij

autoload -U is-at-least

_zellij() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'*--max-panes=[Maximum panes on screen, caution: opening more panes will close old ones]:MAX_PANES: ' \
'*--data-dir=[Change where zellij looks for plugins]:DATA_DIR:_files' \
'*--server=[Run server listening at the specified socket path]:SERVER:_files' \
'*-s+[Specify name of a new session]:SESSION: ' \
'*--session=[Specify name of a new session]:SESSION: ' \
'*-l+[Name of a predefined layout inside the layout directory or the path to a layout file]:LAYOUT:_files' \
'*--layout=[Name of a predefined layout inside the layout directory or the path to a layout file]:LAYOUT:_files' \
'*-c+[Change where zellij looks for the configuration file]:CONFIG:_files' \
'*--config=[Change where zellij looks for the configuration file]:CONFIG:_files' \
'*--config-dir=[Change where zellij looks for the configuration directory]:CONFIG_DIR:_files' \
'-h[Print help information]' \
'--help[Print help information]' \
'-V[Print version information]' \
'--version[Print version information]' \
'*-d[Specify emitting additional debug information]' \
'*--debug[Specify emitting additional debug information]' \
":: :_zellij_commands" \
"*::: :->zellij" \
&& ret=0
    case $state in
    (zellij)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:zellij-command-$line[1]:"
        case $line[1] in
            (options)
_arguments "${_arguments_options[@]}" \
'*--simplified-ui=[Allow plugins to use a more simplified layout that is compatible with more fonts (true or false)]:SIMPLIFIED_UI:(true false)' \
'*--theme=[Set the default theme]:THEME: ' \
'*--default-mode=[Set the default mode]:DEFAULT_MODE:((normal\:"In `Normal` mode, input is always written to the terminal, except for the shortcuts leading to other modes"
locked\:"In `Locked` mode, input is always written to the terminal and all shortcuts are disabled except the one leading back to normal mode"
resize\:"`Resize` mode allows resizing the different existing panes"
pane\:"`Pane` mode allows creating and closing panes, as well as moving between them"
tab\:"`Tab` mode allows creating and closing tabs, as well as moving between them"
scroll\:"`Scroll` mode allows scrolling up and down within a pane"
enter-search\:"`EnterSearch` mode allows for typing in the needle for a search in the scroll buffer of a pane"
search\:"`Search` mode allows for searching a term in a pane (superset of `Scroll`)"
rename-tab\:"`RenameTab` mode allows assigning a new name to a tab"
rename-pane\:"`RenamePane` mode allows assigning a new name to a pane"
session\:"`Session` mode allows detaching sessions"
move\:"`Move` mode allows moving the different existing panes within a tab"
prompt\:"`Prompt` mode allows interacting with active prompts"
tmux\:"`Tmux` mode allows for basic tmux keybindings functionality"))' \
'*--default-shell=[Set the default shell]:DEFAULT_SHELL:_files' \
'*--default-layout=[Set the default layout]:DEFAULT_LAYOUT:_files' \
'*--layout-dir=[Set the layout_dir, defaults to subdirectory of config dir]:LAYOUT_DIR:_files' \
'*--theme-dir=[Set the theme_dir, defaults to subdirectory of config dir]:THEME_DIR:_files' \
'*--mouse-mode=[Set the handling of mouse events (true or false) Can be temporarily bypassed by the \[SHIFT\] key]:MOUSE_MODE:(true false)' \
'*--pane-frames=[Set display of the pane frames (true or false)]:PANE_FRAMES:(true false)' \
'*--mirror-session=[Mirror session when multiple users are connected (true or false)]:MIRROR_SESSION:(true false)' \
'*--on-force-close=[Set behaviour on force close (quit or detach)]:ON_FORCE_CLOSE:(quit detach)' \
'*--scroll-buffer-size=[]:SCROLL_BUFFER_SIZE: ' \
'*--copy-command=[Switch to using a user supplied command for clipboard instead of OSC52]:COPY_COMMAND: ' \
'(--copy-command)*--copy-clipboard=[OSC52 destination clipboard]:COPY_CLIPBOARD:(system primary)' \
'*--copy-on-select=[Automatically copy when selecting text (true or false)]:COPY_ON_SELECT:(true false)' \
'*--scrollback-editor=[Explicit full path to open the scrollback editor (default is $EDITOR or $VISUAL)]:SCROLLBACK_EDITOR:_files' \
'*--session-name=[The name of the session to create when starting Zellij]:SESSION_NAME: ' \
'*--attach-to-session=[Whether to attach to a session specified in "session-name" if it exists]:ATTACH_TO_SESSION:(true false)' \
'*--auto-layout=[Whether to lay out panes in a predefined set of layouts whenever possible]:AUTO_LAYOUT:(true false)' \
'(--mouse-mode)*--disable-mouse-mode[Disable handling of mouse events]' \
'(--pane-frames)*--no-pane-frames[Disable display of pane frames]' \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(setup)
_arguments "${_arguments_options[@]}" \
'*--dump-layout=[Dump the specified layout file to stdout]:DUMP_LAYOUT: ' \
'*--dump-swap-layout=[Dump the specified swap layout file to stdout]:DUMP_SWAP_LAYOUT: ' \
'*--dump-plugins=[Dump the builtin plugins to DIR or "DATA DIR" if unspecified]:DIR:_files' \
'*--generate-completion=[Generates completion for the specified shell]:SHELL: ' \
'*--generate-auto-start=[Generates auto-start script for the specified shell]:SHELL: ' \
'*--dump-config[Dump the default configuration file to stdout]' \
'*--clean[Disables loading of configuration file at default location, loads the defaults that zellij ships with]' \
'*--check[Checks the configuration of zellij and displays currently used directories]' \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(list-sessions)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(attach)
_arguments "${_arguments_options[@]}" \
'*--index=[Number of the session index in the active sessions ordered creation date]:INDEX: ' \
'*-c[Create a session if one does not exist]' \
'*--create[Create a session if one does not exist]' \
'-h[Print help information]' \
'--help[Print help information]' \
'::session-name -- Name of the session to attach to:' \
":: :_zellij__attach_commands" \
"*::: :->attach" \
&& ret=0

    case $state in
    (attach)
        words=($line[2] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:zellij-attach-command-$line[2]:"
        case $line[2] in
            (options)
_arguments "${_arguments_options[@]}" \
'*--simplified-ui=[Allow plugins to use a more simplified layout that is compatible with more fonts (true or false)]:SIMPLIFIED_UI:(true false)' \
'*--theme=[Set the default theme]:THEME: ' \
'*--default-mode=[Set the default mode]:DEFAULT_MODE:((normal\:"In `Normal` mode, input is always written to the terminal, except for the shortcuts leading to other modes"
locked\:"In `Locked` mode, input is always written to the terminal and all shortcuts are disabled except the one leading back to normal mode"
resize\:"`Resize` mode allows resizing the different existing panes"
pane\:"`Pane` mode allows creating and closing panes, as well as moving between them"
tab\:"`Tab` mode allows creating and closing tabs, as well as moving between them"
scroll\:"`Scroll` mode allows scrolling up and down within a pane"
enter-search\:"`EnterSearch` mode allows for typing in the needle for a search in the scroll buffer of a pane"
search\:"`Search` mode allows for searching a term in a pane (superset of `Scroll`)"
rename-tab\:"`RenameTab` mode allows assigning a new name to a tab"
rename-pane\:"`RenamePane` mode allows assigning a new name to a pane"
session\:"`Session` mode allows detaching sessions"
move\:"`Move` mode allows moving the different existing panes within a tab"
prompt\:"`Prompt` mode allows interacting with active prompts"
tmux\:"`Tmux` mode allows for basic tmux keybindings functionality"))' \
'*--default-shell=[Set the default shell]:DEFAULT_SHELL:_files' \
'*--default-layout=[Set the default layout]:DEFAULT_LAYOUT:_files' \
'*--layout-dir=[Set the layout_dir, defaults to subdirectory of config dir]:LAYOUT_DIR:_files' \
'*--theme-dir=[Set the theme_dir, defaults to subdirectory of config dir]:THEME_DIR:_files' \
'*--mouse-mode=[Set the handling of mouse events (true or false) Can be temporarily bypassed by the \[SHIFT\] key]:MOUSE_MODE:(true false)' \
'*--pane-frames=[Set display of the pane frames (true or false)]:PANE_FRAMES:(true false)' \
'*--mirror-session=[Mirror session when multiple users are connected (true or false)]:MIRROR_SESSION:(true false)' \
'*--on-force-close=[Set behaviour on force close (quit or detach)]:ON_FORCE_CLOSE:(quit detach)' \
'*--scroll-buffer-size=[]:SCROLL_BUFFER_SIZE: ' \
'*--copy-command=[Switch to using a user supplied command for clipboard instead of OSC52]:COPY_COMMAND: ' \
'(--copy-command)*--copy-clipboard=[OSC52 destination clipboard]:COPY_CLIPBOARD:(system primary)' \
'*--copy-on-select=[Automatically copy when selecting text (true or false)]:COPY_ON_SELECT:(true false)' \
'*--scrollback-editor=[Explicit full path to open the scrollback editor (default is $EDITOR or $VISUAL)]:SCROLLBACK_EDITOR:_files' \
'*--session-name=[The name of the session to create when starting Zellij]:SESSION_NAME: ' \
'*--attach-to-session=[Whether to attach to a session specified in "session-name" if it exists]:ATTACH_TO_SESSION:(true false)' \
'*--auto-layout=[Whether to lay out panes in a predefined set of layouts whenever possible]:AUTO_LAYOUT:(true false)' \
'(--mouse-mode)*--disable-mouse-mode[Disable handling of mouse events]' \
'(--pane-frames)*--no-pane-frames[Disable display of pane frames]' \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'*::subcommand -- The subcommand whose help message to display:' \
&& ret=0
;;
        esac
    ;;
esac
;;
(kill-session)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
'::target-session -- Name of target session:' \
&& ret=0
;;
(kill-all-sessions)
_arguments "${_arguments_options[@]}" \
'*-y[Automatic yes to prompts]' \
'*--yes[Automatic yes to prompts]' \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(action)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
":: :_zellij__action_commands" \
"*::: :->action" \
&& ret=0

    case $state in
    (action)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:zellij-action-command-$line[1]:"
        case $line[1] in
            (write)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
'*::bytes:' \
&& ret=0
;;
(write-chars)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':chars:' \
&& ret=0
;;
(resize)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':resize:' \
'::direction:' \
&& ret=0
;;
(focus-next-pane)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(focus-previous-pane)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(move-focus)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':direction:' \
&& ret=0
;;
(move-focus-or-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':direction:' \
&& ret=0
;;
(move-pane)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
'::direction:' \
&& ret=0
;;
(move-pane-backwards)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(dump-screen)
_arguments "${_arguments_options[@]}" \
'*-f[Dump the pane with full scrollback]' \
'*--full[Dump the pane with full scrollback]' \
'-h[Print help information]' \
'--help[Print help information]' \
':path:' \
&& ret=0
;;
(edit-scrollback)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(scroll-up)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(scroll-down)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(scroll-to-bottom)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(scroll-to-top)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(page-scroll-up)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(page-scroll-down)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(half-page-scroll-up)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(half-page-scroll-down)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(toggle-fullscreen)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(toggle-pane-frames)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(toggle-active-sync-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(new-pane)
_arguments "${_arguments_options[@]}" \
'(-f --floating)*-d+[Direction to open the new pane in]:DIRECTION: ' \
'(-f --floating)*--direction=[Direction to open the new pane in]:DIRECTION: ' \
'*--cwd=[Change the working directory of the new pane]:CWD:_files' \
'*-n+[Name of the new pane]:NAME: ' \
'*--name=[Name of the new pane]:NAME: ' \
'*-f[Open the new pane in floating mode]' \
'*--floating[Open the new pane in floating mode]' \
'*-c[Close the pane immediately when its command exits]' \
'*--close-on-exit[Close the pane immediately when its command exits]' \
'*-s[Start the command suspended, only running it after the you first press ENTER]' \
'*--start-suspended[Start the command suspended, only running it after the you first press ENTER]' \
'-h[Print help information]' \
'--help[Print help information]' \
'*::command:' \
&& ret=0
;;
(edit)
_arguments "${_arguments_options[@]}" \
'(-f --floating)*-d+[Direction to open the new pane in]:DIRECTION: ' \
'(-f --floating)*--direction=[Direction to open the new pane in]:DIRECTION: ' \
'*-l+[Open the file in the specified line number]:LINE_NUMBER: ' \
'*--line-number=[Open the file in the specified line number]:LINE_NUMBER: ' \
'*--cwd=[Change the working directory of the editor]:CWD:_files' \
'*-f[Open the new pane in floating mode]' \
'*--floating[Open the new pane in floating mode]' \
'-h[Print help information]' \
'--help[Print help information]' \
':file:' \
&& ret=0
;;
(switch-mode)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':input-mode:' \
&& ret=0
;;
(toggle-pane-embed-or-floating)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(toggle-floating-panes)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(close-pane)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(rename-pane)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':name:' \
&& ret=0
;;
(undo-rename-pane)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(go-to-next-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(go-to-previous-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(close-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(go-to-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':index:' \
&& ret=0
;;
(go-to-tab-name)
_arguments "${_arguments_options[@]}" \
'*-c[Create a tab if one does not exist]' \
'*--create[Create a tab if one does not exist]' \
'-h[Print help information]' \
'--help[Print help information]' \
':name:' \
&& ret=0
;;
(rename-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':name:' \
&& ret=0
;;
(undo-rename-tab)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(new-tab)
_arguments "${_arguments_options[@]}" \
'*-l+[Layout to use for the new tab]:LAYOUT:_files' \
'*--layout=[Layout to use for the new tab]:LAYOUT:_files' \
'*--layout-dir=[Default folder to look for layouts]:LAYOUT_DIR:_files' \
'*-n+[Name of the new tab]:NAME: ' \
'*--name=[Name of the new tab]:NAME: ' \
'*-c+[Change the working directory of the new tab]:CWD:_files' \
'*--cwd=[Change the working directory of the new tab]:CWD:_files' \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(previous-swap-layout)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(next-swap-layout)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(query-tab-names)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'*::subcommand -- The subcommand whose help message to display:' \
&& ret=0
;;
        esac
    ;;
esac
;;
(run)
_arguments "${_arguments_options[@]}" \
'(-f --floating)*-d+[Direction to open the new pane in]:DIRECTION: ' \
'(-f --floating)*--direction=[Direction to open the new pane in]:DIRECTION: ' \
'*--cwd=[Change the working directory of the new pane]:CWD:_files' \
'*-n+[Name of the new pane]:NAME: ' \
'*--name=[Name of the new pane]:NAME: ' \
'*-f[Open the new pane in floating mode]' \
'*--floating[Open the new pane in floating mode]' \
'*-c[Close the pane immediately when its command exits]' \
'*--close-on-exit[Close the pane immediately when its command exits]' \
'*-s[Start the command suspended, only running after you first presses ENTER]' \
'*--start-suspended[Start the command suspended, only running after you first presses ENTER]' \
'-h[Print help information]' \
'--help[Print help information]' \
'*::command -- Command to run:' \
&& ret=0
;;
(edit)
_arguments "${_arguments_options[@]}" \
'*-l+[Open the file in the specified line number]:LINE_NUMBER: ' \
'*--line-number=[Open the file in the specified line number]:LINE_NUMBER: ' \
'(-f --floating)*-d+[Direction to open the new pane in]:DIRECTION: ' \
'(-f --floating)*--direction=[Direction to open the new pane in]:DIRECTION: ' \
'*--cwd=[Change the working directory of the editor]:CWD:_files' \
'*-f[Open the new pane in floating mode]' \
'*--floating[Open the new pane in floating mode]' \
'-h[Print help information]' \
'--help[Print help information]' \
':file:' \
&& ret=0
;;
(convert-config)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':old-config-file:' \
&& ret=0
;;
(convert-layout)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':old-layout-file:' \
&& ret=0
;;
(convert-theme)
_arguments "${_arguments_options[@]}" \
'-h[Print help information]' \
'--help[Print help information]' \
':old-theme-file:' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'*::subcommand -- The subcommand whose help message to display:' \
&& ret=0
;;
        esac
    ;;
esac
}

(( $+functions[_zellij_commands] )) ||
_zellij_commands() {
    local commands; commands=(
'options:Change the behaviour of zellij' \
'setup:Setup zellij and check its configuration' \
'list-sessions:List active sessions' \
'ls:List active sessions' \
'attach:Attach to a session' \
'a:Attach to a session' \
'kill-session:Kill the specific session' \
'k:Kill the specific session' \
'kill-all-sessions:Kill all sessions' \
'ka:Kill all sessions' \
'action:Send actions to a specific session' \
'ac:Send actions to a specific session' \
'run:Run a command in a new pane' \
'r:Run a command in a new pane' \
'edit:Edit file with default $EDITOR / $VISUAL' \
'e:Edit file with default $EDITOR / $VISUAL' \
'convert-config:' \
'convert-layout:' \
'convert-theme:' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'zellij commands' commands "$@"
}
(( $+functions[_zellij__action_commands] )) ||
_zellij__action_commands() {
    local commands; commands=(
'write:Write bytes to the terminal' \
'write-chars:Write characters to the terminal' \
'resize:\[increase|decrease\] the focused panes area at the \[left|down|up|right\] border' \
'focus-next-pane:Change focus to the next pane' \
'focus-previous-pane:Change focus to the previous pane' \
'move-focus:Move the focused pane in the specified direction. \[right|left|up|down\]' \
'move-focus-or-tab:Move focus to the pane or tab (if on screen edge) in the specified direction \[right|left|up|down\]' \
'move-pane:Change the location of the focused pane in the specified direction or rotate forwrads \[right|left|up|down\]' \
'move-pane-backwards:Rotate the location of the previous pane backwards' \
'dump-screen:Dump the focused pane to a file' \
'edit-scrollback:Open the pane scrollback in your default editor' \
'scroll-up:Scroll up in the focused pane' \
'scroll-down:Scroll down in focus pane' \
'scroll-to-bottom:Scroll down to bottom in focus pane' \
'scroll-to-top:Scroll up to top in focus pane' \
'page-scroll-up:Scroll up one page in focus pane' \
'page-scroll-down:Scroll down one page in focus pane' \
'half-page-scroll-up:Scroll up half page in focus pane' \
'half-page-scroll-down:Scroll down half page in focus pane' \
'toggle-fullscreen:Toggle between fullscreen focus pane and normal layout' \
'toggle-pane-frames:Toggle frames around panes in the UI' \
'toggle-active-sync-tab:Toggle between sending text commands to all panes on the current tab and normal mode' \
'new-pane:Open a new pane in the specified direction \[right|down\] If no direction is specified, will try to use the biggest available space' \
'edit:Open the specified file in a new zellij pane with your default EDITOR' \
'switch-mode:Switch input mode of all connected clients \[locked|pane|tab|resize|move|search|session\]' \
'toggle-pane-embed-or-floating:Embed focused pane if floating or float focused pane if embedded' \
'toggle-floating-panes:Toggle the visibility of all fdirectionloating panes in the current Tab, open one if none exist' \
'close-pane:Close the focused pane' \
'rename-pane:Renames the focused pane' \
'undo-rename-pane:Remove a previously set pane name' \
'go-to-next-tab:Go to the next tab' \
'go-to-previous-tab:Go to the previous tab' \
'close-tab:Close the current tab' \
'go-to-tab:Go to tab with index \[index\]' \
'go-to-tab-name:Go to tab with name \[name\]' \
'rename-tab:Renames the focused pane' \
'undo-rename-tab:Remove a previously set tab name' \
'new-tab:Create a new tab, optionally with a specified tab layout and name' \
'previous-swap-layout:' \
'next-swap-layout:' \
'query-tab-names:Query all tab names' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'zellij action commands' commands "$@"
}
(( $+functions[_zellij__attach_commands] )) ||
_zellij__attach_commands() {
    local commands; commands=(
'options:Change the behaviour of zellij' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'zellij attach commands' commands "$@"
}
(( $+functions[_zellij__action__close-pane_commands] )) ||
_zellij__action__close-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action close-pane commands' commands "$@"
}
(( $+functions[_zellij__action__close-tab_commands] )) ||
_zellij__action__close-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action close-tab commands' commands "$@"
}
(( $+functions[_zellij__convert-config_commands] )) ||
_zellij__convert-config_commands() {
    local commands; commands=()
    _describe -t commands 'zellij convert-config commands' commands "$@"
}
(( $+functions[_zellij__convert-layout_commands] )) ||
_zellij__convert-layout_commands() {
    local commands; commands=()
    _describe -t commands 'zellij convert-layout commands' commands "$@"
}
(( $+functions[_zellij__convert-theme_commands] )) ||
_zellij__convert-theme_commands() {
    local commands; commands=()
    _describe -t commands 'zellij convert-theme commands' commands "$@"
}
(( $+functions[_zellij__action__dump-screen_commands] )) ||
_zellij__action__dump-screen_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action dump-screen commands' commands "$@"
}
(( $+functions[_zellij__action__edit_commands] )) ||
_zellij__action__edit_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action edit commands' commands "$@"
}
(( $+functions[_zellij__edit_commands] )) ||
_zellij__edit_commands() {
    local commands; commands=()
    _describe -t commands 'zellij edit commands' commands "$@"
}
(( $+functions[_zellij__action__edit-scrollback_commands] )) ||
_zellij__action__edit-scrollback_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action edit-scrollback commands' commands "$@"
}
(( $+functions[_zellij__action__focus-next-pane_commands] )) ||
_zellij__action__focus-next-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action focus-next-pane commands' commands "$@"
}
(( $+functions[_zellij__action__focus-previous-pane_commands] )) ||
_zellij__action__focus-previous-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action focus-previous-pane commands' commands "$@"
}
(( $+functions[_zellij__action__go-to-next-tab_commands] )) ||
_zellij__action__go-to-next-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action go-to-next-tab commands' commands "$@"
}
(( $+functions[_zellij__action__go-to-previous-tab_commands] )) ||
_zellij__action__go-to-previous-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action go-to-previous-tab commands' commands "$@"
}
(( $+functions[_zellij__action__go-to-tab_commands] )) ||
_zellij__action__go-to-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action go-to-tab commands' commands "$@"
}
(( $+functions[_zellij__action__go-to-tab-name_commands] )) ||
_zellij__action__go-to-tab-name_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action go-to-tab-name commands' commands "$@"
}
(( $+functions[_zellij__action__half-page-scroll-down_commands] )) ||
_zellij__action__half-page-scroll-down_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action half-page-scroll-down commands' commands "$@"
}
(( $+functions[_zellij__action__half-page-scroll-up_commands] )) ||
_zellij__action__half-page-scroll-up_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action half-page-scroll-up commands' commands "$@"
}
(( $+functions[_zellij__action__help_commands] )) ||
_zellij__action__help_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action help commands' commands "$@"
}
(( $+functions[_zellij__attach__help_commands] )) ||
_zellij__attach__help_commands() {
    local commands; commands=()
    _describe -t commands 'zellij attach help commands' commands "$@"
}
(( $+functions[_zellij__help_commands] )) ||
_zellij__help_commands() {
    local commands; commands=()
    _describe -t commands 'zellij help commands' commands "$@"
}
(( $+functions[_zellij__kill-all-sessions_commands] )) ||
_zellij__kill-all-sessions_commands() {
    local commands; commands=()
    _describe -t commands 'zellij kill-all-sessions commands' commands "$@"
}
(( $+functions[_zellij__kill-session_commands] )) ||
_zellij__kill-session_commands() {
    local commands; commands=()
    _describe -t commands 'zellij kill-session commands' commands "$@"
}
(( $+functions[_zellij__list-sessions_commands] )) ||
_zellij__list-sessions_commands() {
    local commands; commands=()
    _describe -t commands 'zellij list-sessions commands' commands "$@"
}
(( $+functions[_zellij__action__move-focus_commands] )) ||
_zellij__action__move-focus_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action move-focus commands' commands "$@"
}
(( $+functions[_zellij__action__move-focus-or-tab_commands] )) ||
_zellij__action__move-focus-or-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action move-focus-or-tab commands' commands "$@"
}
(( $+functions[_zellij__action__move-pane_commands] )) ||
_zellij__action__move-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action move-pane commands' commands "$@"
}
(( $+functions[_zellij__action__move-pane-backwards_commands] )) ||
_zellij__action__move-pane-backwards_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action move-pane-backwards commands' commands "$@"
}
(( $+functions[_zellij__action__new-pane_commands] )) ||
_zellij__action__new-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action new-pane commands' commands "$@"
}
(( $+functions[_zellij__action__new-tab_commands] )) ||
_zellij__action__new-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action new-tab commands' commands "$@"
}
(( $+functions[_zellij__action__next-swap-layout_commands] )) ||
_zellij__action__next-swap-layout_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action next-swap-layout commands' commands "$@"
}
(( $+functions[_zellij__attach__options_commands] )) ||
_zellij__attach__options_commands() {
    local commands; commands=()
    _describe -t commands 'zellij attach options commands' commands "$@"
}
(( $+functions[_zellij__options_commands] )) ||
_zellij__options_commands() {
    local commands; commands=()
    _describe -t commands 'zellij options commands' commands "$@"
}
(( $+functions[_zellij__action__page-scroll-down_commands] )) ||
_zellij__action__page-scroll-down_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action page-scroll-down commands' commands "$@"
}
(( $+functions[_zellij__action__page-scroll-up_commands] )) ||
_zellij__action__page-scroll-up_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action page-scroll-up commands' commands "$@"
}
(( $+functions[_zellij__action__previous-swap-layout_commands] )) ||
_zellij__action__previous-swap-layout_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action previous-swap-layout commands' commands "$@"
}
(( $+functions[_zellij__action__query-tab-names_commands] )) ||
_zellij__action__query-tab-names_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action query-tab-names commands' commands "$@"
}
(( $+functions[_zellij__action__rename-pane_commands] )) ||
_zellij__action__rename-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action rename-pane commands' commands "$@"
}
(( $+functions[_zellij__action__rename-tab_commands] )) ||
_zellij__action__rename-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action rename-tab commands' commands "$@"
}
(( $+functions[_zellij__action__resize_commands] )) ||
_zellij__action__resize_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action resize commands' commands "$@"
}
(( $+functions[_zellij__run_commands] )) ||
_zellij__run_commands() {
    local commands; commands=()
    _describe -t commands 'zellij run commands' commands "$@"
}
(( $+functions[_zellij__action__scroll-down_commands] )) ||
_zellij__action__scroll-down_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action scroll-down commands' commands "$@"
}
(( $+functions[_zellij__action__scroll-to-bottom_commands] )) ||
_zellij__action__scroll-to-bottom_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action scroll-to-bottom commands' commands "$@"
}
(( $+functions[_zellij__action__scroll-to-top_commands] )) ||
_zellij__action__scroll-to-top_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action scroll-to-top commands' commands "$@"
}
(( $+functions[_zellij__action__scroll-up_commands] )) ||
_zellij__action__scroll-up_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action scroll-up commands' commands "$@"
}
(( $+functions[_zellij__setup_commands] )) ||
_zellij__setup_commands() {
    local commands; commands=()
    _describe -t commands 'zellij setup commands' commands "$@"
}
(( $+functions[_zellij__action__switch-mode_commands] )) ||
_zellij__action__switch-mode_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action switch-mode commands' commands "$@"
}
(( $+functions[_zellij__action__toggle-active-sync-tab_commands] )) ||
_zellij__action__toggle-active-sync-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action toggle-active-sync-tab commands' commands "$@"
}
(( $+functions[_zellij__action__toggle-floating-panes_commands] )) ||
_zellij__action__toggle-floating-panes_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action toggle-floating-panes commands' commands "$@"
}
(( $+functions[_zellij__action__toggle-fullscreen_commands] )) ||
_zellij__action__toggle-fullscreen_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action toggle-fullscreen commands' commands "$@"
}
(( $+functions[_zellij__action__toggle-pane-embed-or-floating_commands] )) ||
_zellij__action__toggle-pane-embed-or-floating_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action toggle-pane-embed-or-floating commands' commands "$@"
}
(( $+functions[_zellij__action__toggle-pane-frames_commands] )) ||
_zellij__action__toggle-pane-frames_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action toggle-pane-frames commands' commands "$@"
}
(( $+functions[_zellij__action__undo-rename-pane_commands] )) ||
_zellij__action__undo-rename-pane_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action undo-rename-pane commands' commands "$@"
}
(( $+functions[_zellij__action__undo-rename-tab_commands] )) ||
_zellij__action__undo-rename-tab_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action undo-rename-tab commands' commands "$@"
}
(( $+functions[_zellij__action__write_commands] )) ||
_zellij__action__write_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action write commands' commands "$@"
}
(( $+functions[_zellij__action__write-chars_commands] )) ||
_zellij__action__write-chars_commands() {
    local commands; commands=()
    _describe -t commands 'zellij action write-chars commands' commands "$@"
}

_zellij "$@"
function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}
