{ ... }: {

  services.xserver = {

    layout = "us";

    # Keyboard responsiveness
    autoRepeatDelay = 250;
    autoRepeatInterval = 40;

    # Swap escape key with caps lock key
    xkbOptions = "eurosign:e,caps:swapescape";

  };

}