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
      "imageoptim"
      "discord"
      "anki"
	  "font-sf-mono"
	  "font-sf-pro"
      "transmission"
      "keyboardcleantool"
      "betterdisplay"
      "iterm2"
      "signal"
      "hyperkey"
      "obs"
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
