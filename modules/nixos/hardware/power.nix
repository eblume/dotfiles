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
}
