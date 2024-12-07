{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aria2
    btop
    eza
    gh
    go
    nim
    nimble
    tree
    nodejs
    starship
    fastfetch
	bat
	#sketchybar-app-font
	#lua5_4
	spoofdpi
	qemu
  ];

  # Launchd
  launchd = {
    user = {
	  agents = {
	    spoofdpi = {
		  command = "${pkgs.spoofdpi}/bin/spoofdpi -enable-doh -window-size 1 -pattern '\\bdiscord\\b' -pattern '\\bdiscordapp\\b' -pattern '\\bnyaa\\b'";
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
	  "font-hack-nerd-font"
	  "sf-symbols"
	  "font-sf-mono"
	  "font-sf-pro"
	  "microsoft-teams"
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
	  "aldente"
	  "notion"
	  "hyperkey"
	  "affinity-designer"
	  "affinity-photo"
	  "affinity-publisher"
      "lens"
    ];
  };
}
