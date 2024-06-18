{ pkgs, config, ... }: {
  # Erich's custom ssh-agent config:
  # Check to see if an SSH_AUTH_SOCK is set, and if it is, check for my key.
  # If the key is absent, load it from 1password. (This can block via a GUI prompt.)
  # If SSH_AUTH_SOCK is not set, start a new ssh-agent and load the key.

  home-manager.users.${config.user} = let
    fingerprint = "SHA256:Cd7uCMYhbDqZ09P3fAkf6tFdj8dWmwbWs8kk2skVNpw"
  in {

    home.sessionVariables = {
      OP_BIOMETRIC_UNLOCK_ENABLED = true;
    };

    # TODO draw the rest of the owl
    # (something with interactiveShellInit, but still WIP)
    
  };
};
