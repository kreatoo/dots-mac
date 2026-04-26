{ pkgs, lib, systemName, ... }:
{
  config = lib.mkIf (systemName != "work") {
    home.packages = with pkgs; [
      nim
      nimble
      yt-dlp
      android-tools
      cloudflared
      jellyfin-tui
      ghidra-bin
      nodejs
      cursor-cli
      claude-code
    ];
  };
}