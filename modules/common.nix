{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alt-tab-macos
    iina
    the-unarchiver
    rectangle
    audacity
  ];

  homebrew.casks = [
    "sf-symbols"
    "stats"
    "imageoptim"
    "iterm2"
    "raycast"
    "hyperkey"
    "cap"
    "font-sf-mono"
    "font-sf-pro"
    "keyboardcleantool"
    "betterdisplay"
    "whatsapp"
    "obs"
  ];
}
