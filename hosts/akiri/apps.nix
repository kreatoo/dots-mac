{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aria2
    btop
    eza
    gh
    go
    nim
    tree
    nodejs
    starship
    fastfetch
	bat
	spoofdpi
  ];

  # Launchd
  launchd = {
    user = {
	  agents = {
	    spoofdpi = {
		  command = "${pkgs.spoofdpi}/bin/spoofdpi -enable-doh -window-size 1 -pattern '\\bdiscord\\b'";
		  serviceConfig = {
		    RunAtLoad = true;
		    KeepAlive = true;
		    StandardOutPath = "/dev/null";
		    StandardErrorPath = "/dev/null";
		  };
		};
	  };
	};
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };

    casks = [
      "1password"
	  "transmission"
      "alt-tab"
      "docker"
      "iterm2"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "keyboardcleantool"
      "rectangle"
      "signal"
      "soundsource"
      "stremio"
      "the-unarchiver"
      "tuta-mail"
      "utm"
      "vivaldi"
      "discord"
	  "iina"
    ];
  };
}
