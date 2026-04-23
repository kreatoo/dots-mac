{ pkgs, nixpkgs-2511, ... }:
let
  pkgs-2511 = nixpkgs-2511.legacyPackages.${pkgs.system};
in
{
  environment.systemPackages =
    with pkgs;
    [
      gzdoom
      scrcpy
      localsend
      prismlauncher
      cinny-desktop
      upscayl
      moonlight-qt
      pear-desktop
      cyberduck
      utm
    ]
    ++ [
      pkgs-2511.spoofdpi
    ];

  homebrew.casks = [
    "discord"
    "transmission"
    "antigravity"
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
