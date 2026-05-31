{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      gzdoom
      scrcpy
      localsend
      #prismlauncher
      cinny-desktop
      upscayl
      moonlight-qt
      pear-desktop
      cyberduck
      utm
    ];

  homebrew.casks = [
    "discord"
    "transmission"
    "antigravity"
    "mullvad-vpn"
    "lm-studio"
    "playcover-community"
    "vivaldi"
    "chatwise"
    "garmin-express"
    "tradingview"
    "signal"
    "affinity-designer"
    "affinity-photo"
    "affinity-publisher"
    "synology-drive"
    "1password"
    "virtual-desktop-streamer"
    "android-studio"
    "finetune"
  ];
}
