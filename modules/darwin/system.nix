{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf pkgs.stdenv.isDarwin {

    environment.shells = [ pkgs.fish ];

    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      stateVersion = 5;

      # Part of a migration towards fully multiuser nix-darwin
      primaryUser = "${config.user}";

      keyboard = {
        remapCapsLockToControl = true;
        enableKeyMapping = true; # Allows for skhd
      };

      defaults = {
        NSGlobalDomain = {

          # Set to dark mode
          AppleInterfaceStyle = "Dark";

          # Don't change from dark to light automatically
          # AppleInterfaceSwitchesAutomatically = false;

          # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
          AppleKeyboardUIMode = 3;

          # Only hide menu bar in fullscreen
          _HIHideMenuBar = false;

          # Expand save panel by default
          NSNavPanelExpandedStateForSaveMode = true;

          # Expand print panel by default
          PMPrintingExpandedStateForPrint = true;

          # Replace press-and-hold with key repeat
          ApplePressAndHoldEnabled = false;

          # Set a fast key repeat rate
          KeyRepeat = 2;

          # Shorten delay before key repeat begins
          InitialKeyRepeat = 12;

          # Save to local disk by default, not iCloud
          NSDocumentSaveNewDocumentsToCloud = false;

          # Disable autocorrect capitalization
          NSAutomaticCapitalizationEnabled = false;

          # Disable autocorrect smart dashes
          NSAutomaticDashSubstitutionEnabled = false;

          # Disable autocorrect adding periods
          NSAutomaticPeriodSubstitutionEnabled = false;

          # Disable autocorrect smart quotation marks
          NSAutomaticQuoteSubstitutionEnabled = false;

          # Disable autocorrect spellcheck
          NSAutomaticSpellingCorrectionEnabled = false;
        };

        dock = {
          # Automatically show and hide the dock
          autohide = true;

          # Add translucency in dock for hidden applications
          showhidden = true;

          # Enable spring loading on all dock items
          enable-spring-load-actions-on-all-items = true;

          # Highlight hover effect in dock stack grid view
          mouse-over-hilite-stack = true;

          mineffect = "genie";
          orientation = "bottom";
          show-recents = false;
          tilesize = 44;

          persistent-apps = [
            "/Applications/1Password.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Messages.app"
            "/System/Applications/Mail.app"
            "/Applications/WezTerm.app"
            "/System/Applications/System Settings.app"
            "/Applications/Slack.app"
          ];

          # Disable all of the hot corner actions (Disabled = 1)
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };

        finder = {

          # Default Finder window set to column view
          FXPreferredViewStyle = "clmv";

          # Finder search in current folder by default
          FXDefaultSearchScope = "SCcf";

          # Disable warning when changing file extension
          FXEnableExtensionChangeWarning = false;

          # Allow quitting of Finder application
          QuitMenuItem = true;

          # Show all extensions in finder
          AppleShowAllExtensions = true;
        };

        # Disable "Are you sure you want to open" dialog
        LaunchServices.LSQuarantine = false;

        # Disable trackpad tap to click
        trackpad.Clicking = false;

        # Where to save screenshots
        screencapture.location = "~/Downloads";

        CustomUserPreferences = {
          # Disable disk image verification
          "com.apple.frameworks.diskimages" = {
            skip-verify = true;
            skip-verify-locked = true;
            skip-verify-remote = true;
          };
          # Avoid creating .DS_Store files on network or USB volumes
          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.dock" = {
            magnification = true;
            largesize = 48;
          };
          # Require password immediately after screen saver begins
          "com.apple.screensaver" = {
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.finder" = {
            # Disable the warning before emptying the Trash
            WarnOnEmptyTrash = false;

            # Finder search in current folder by default
            FXDefaultSearchScope = "SCcf";

            # Default Finder window set to column view
            FXPreferredViewStyle = "clmv";
          };
        };

        CustomSystemPreferences = {

        };
      };
    };
  };
}
