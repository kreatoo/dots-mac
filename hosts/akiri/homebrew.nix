let
  vars = import ./options.nix;
in
{
  homebrew = {
    enable = vars.homebrew.enable;
    
	onActivation = {
      autoUpdate = vars.homebrew.autoUpdate;
      cleanup = if vars.homebrew.declarative then "uninstall" else "none";
    };

    taps = [
        "PlayCover/playcover"
    ];

    casks = [
      "1password"
      "blackhole-16ch"
      "balenaetcher"
	  "sf-symbols"
      "imageoptim"
      "discord"
      "garmin-express"
      "tradingview"
	  "font-sf-mono"
	  "font-sf-pro"
      "cap"
      "transmission"
      "keyboardcleantool"
      "betterdisplay"
      "iterm2"
      "signal"
      "whatsapp"
      "hyperkey"
      "obs"
      "android-studio"
      "raycast"
	  "affinity-designer"
	  "affinity-photo"
      "synology-drive"
	  "affinity-publisher"
      "chatwise"
      "vivaldi"
      "playcover-community"
    ];
  };
}
