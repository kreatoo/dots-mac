{ pkgs, lib, systemName, ... }:
{
  config = lib.mkIf (systemName != "work") {
    programs.opencode.settings.mcp.megaten_fusion = {
      type = "local";
      command = [
        "bun"
        "x"
        "megaten-fusion-mcp"
      ];
      enabled = true;
    };

    home.packages = with pkgs; [
      nim
      nimble
      yt-dlp
      android-tools
      cloudflared
      jellyfin-tui
      ghidra-bin
      nodejs
    ];
  };
}
