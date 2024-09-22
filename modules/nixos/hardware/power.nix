{ ... }:
{
  # Power Management
  # For now I'm just trying to get some observability in to why I can't always
  # resume using ringtail after leaving it alone for a few hours. It's some
  # sort of freeze, but it's not completely clear what is freezing.

  powerManagement.resumeCommands = ''
    echo "dotfiles/.../power.nix: powerManagement.resumeCommands"
  '';

  ## And while i'm at it, let's just turn this all off.
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  ## Try and fix issue where I wake up to a frozen machine and lots of "CPU Stuck" watchdog errors
  # https://discourse.nixos.org/t/stop-pc-from-sleep/5757/2
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
