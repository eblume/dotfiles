{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    wezterm = {
      enable = lib.mkEnableOption {
        description = "Enable WezTerm terminal.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.wezterm.enable) {
    home-manager.users.${config.user} = {

      # Set the i3 terminal
      xsession.windowManager.i3.config.terminal = lib.mkIf pkgs.stdenv.isLinux "wezterm";

      # Display images in the terminal
      programs.fish.shellAliases = {
        icat = lib.mkForce "wezterm imgcat";
      };

      programs.wezterm = {
        enable = true;
        colorSchemes = {
          myTheme = {
            background = config.theme.colors.base00;
            foreground = config.theme.colors.base05;
            cursor_bg = config.theme.colors.base05;
            cursor_fg = config.theme.colors.base00;
            cursor_border = config.theme.colors.base05;
            selection_bg = config.theme.colors.base05;
            selection_fg = config.theme.colors.base00;
            scrollbar_thumb = config.theme.colors.base03;
            ansi = [
              config.theme.colors.base01 # black
              config.theme.colors.base0F # maroon
              config.theme.colors.base0B # green
              config.theme.colors.base0A # olive
              config.theme.colors.base0D # navy
              config.theme.colors.base0E # purple
              config.theme.colors.base0C # teal
              config.theme.colors.base06 # silver
            ];
            brights = [
              config.theme.colors.base03 # grey
              config.theme.colors.base08 # red
              config.theme.colors.base0B # lime
              config.theme.colors.base0A # yellow
              config.theme.colors.base0D # blue
              config.theme.colors.base0E # fuchsia
              config.theme.colors.base0C # aqua
              config.theme.colors.base07 # white
            ];
            compose_cursor = config.theme.colors.base09; # orange
            copy_mode_active_highlight_bg = {
              Color = config.theme.colors.base03;
            };
            copy_mode_active_highlight_fg = {
              Color = config.theme.colors.base07;
            };
            copy_mode_inactive_highlight_bg = {
              Color = config.theme.colors.base02;
            };
            copy_mode_inactive_highlight_fg = {
              Color = config.theme.colors.base06;
            };
            quick_select_label_bg = {
              Color = config.theme.colors.base02;
            };
            quick_select_label_fg = {
              Color = config.theme.colors.base06;
            };
            quick_select_match_bg = {
              Color = config.theme.colors.base03;
            };
            quick_select_match_fg = {
              Color = config.theme.colors.base07;
            };
          };
        };
        extraConfig = ''
          return {
              -- Theme
              color_scheme = "myTheme",

              -- Scrollback
              scrollback_lines = 10000,

              -- Not sure why, but Im getting lots of errors.
              warn_about_missing_glyphs = false,

              -- Window
              window_padding = {
                left = 10,
                right = 10,
                top = 10,
                bottom = 10,
              },

              -- Font
              font_size = ${if pkgs.stdenv.isLinux then "14.0" else "18.0"},
              font = wezterm.font_with_fallback({
                { family = "VictorMono Nerd Font" },
                { family = "Arial" },
              }),

              -- Tab Bar
              hide_tab_bar_if_only_one_tab = true,
              window_frame = {
                font_size = ${if pkgs.stdenv.isLinux then "12.0" else "16.0"},
              },

              colors = {
                tab_bar = {
                  active_tab = {
                    bg_color = '${config.theme.colors.base00}',
                    fg_color = '${config.theme.colors.base04}',
                  },
                },
              },

              -- Disable audio
              audible_bell = "Disabled",

              keys = {
                -- sends completion string for fish autosuggestions
                {
                  key = 'Enter',
                  mods = 'SHIFT',
                  action = wezterm.action.SendString '\x1F'
                },
                -- ctrl-shift-h was "hide"
                {
                  key = 'H',
                  mods = 'SHIFT|CTRL',
                  action = wezterm.action.DisableDefaultAssignment
                },
                -- alt-enter was "fullscreen"
                {
                  key = 'Enter',
                  mods = 'ALT',
                  action = wezterm.action.DisableDefaultAssignment
                },
                -- make super-f "fullscreen"
                {
                  key = 'f',
                  mods = 'SUPER',
                  action = wezterm.action.ToggleFullScreen
                },
                -- super-t open new tab in new dir
                {
                  key = 't',
                  mods = 'SUPER',
                  action = wezterm.action.SpawnCommandInNewTab {
                    cwd = wezterm.home_dir,
                  },
                },
                -- shift-super-t open new tab in same dir
                {
                  key = 't',
                  mods = 'SUPER|SHIFT',
                  action = wezterm.action.SpawnTab 'CurrentPaneDomain'
                },
              },
          }
        '';
      };
    };
  };
}
