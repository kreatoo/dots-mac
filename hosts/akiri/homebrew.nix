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
      "galaxybudsclient"
      "easy-move+resize"
	  "sf-symbols"
      "droid"
      "imageoptim"
      "discord"
      "garmin-express"
      "anki"
	  "font-sf-mono"
      "affine"
	  "font-sf-pro"
      "jordanbaird-ice@beta"
      "cap"
      "transmission"
      "inkscape"
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
