{ pkgs, ... }:

let
  vars = import ./options.nix;
in
{
  # Enable Steam Deck hardware support
  jovian.devices.steamdeck.enable = true;

  # Configure Steam Deck UI (Gaming Mode)
  jovian.steam = {
    enable = true; # Enable Steam Deck UI
    autoStart = true; # Start Gaming Mode on boot
    user = vars.userName; # User to run Steam as (deck)
    desktopSession = "gnome"; # Desktop environment for "Switch to Desktop"
  };

  # Enable Decky Loader plugin system
  jovian.decky-loader = {
    enable = true;
    user = vars.userName;
    stateDir = "/var/lib/decky-loader";

    # Add extra system packages to PATH for plugins
    extraPackages = with pkgs; [
      curl
      unzip
      git
    ];

    # Add extra Python packages for plugins
    extraPythonPackages =
      pythonPackages: with pythonPackages; [
        requests
        pillow
      ];
  };

  # Enable SteamOS-style system configuration
  # This includes automount, Bluetooth, boot settings, and memory management
  jovian.steamos.useSteamOSConfig = true;
}
