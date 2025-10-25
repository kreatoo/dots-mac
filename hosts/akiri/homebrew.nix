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
      "balenaetcher"
      "galaxybudsclient"
      "easy-move+resize"
	  "sf-symbols"
      "droid"
      "imageoptim"
      "discord"
      "garmin-express"
      "anki"
	  "font-sf-mono"
	  "font-sf-pro"
      "cap"
      "transmission"
      "inkscape"
      "tradingview"
      "keyboardcleantool"
      "betterdisplay"
      "iterm2"
      "signal"
      "hyperkey"
      "obs"
      "android-studio"
      "cursor"
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
