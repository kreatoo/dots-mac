let
  vars = import ./options.nix;
in
{
  # Enable X server and GNOME desktop environment for desktop mode
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  systemd.services.display-manager.enable = false;

  # Hostname configuration
  networking.hostName = vars.hostName;

  # Timezone from common settings
  time.timeZone = vars.time.timeZone;

  # System state version for NixOS
  system.stateVersion = "24.11";

  # Platform architecture for Steam Deck
  nixpkgs.hostPlatform = "x86_64-linux";
}
