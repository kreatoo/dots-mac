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
    watch
    k9s
    docker
  ];

  # Launchd
  launchd = {
    user = {
	  agents = {
	    spoofdpi = {
		  command = "${pkgs.spoofdpi}/bin/spoofdpi -enable-doh -window-size 1 -pattern '\\bdiscord\\b' -pattern '\\bdiscordapp\\b' -pattern '\\bnyaa\\b' -pattern '\\bgelbooru\\b' -pattern '\\bdanbooru\\b' -pattern '\\btumblr\\b' -pattern '\\b4chan\\b' -pattern '\\bhianime\\b' -pattern '\\bpastebin\\b' -pattern '\\bwikihow\\b'";
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

    taps = [
        "PlayCover/playcover"
    ];

    casks = [
      "1password"
      "yaak"
      "cursor"
      "balenaetcher"
      "galaxybudsclient"
      "localsend"
      "msty"
      "arc"
      "lm-studio"
      "gzdoom"
      "orbstack"
	  "transmission"
      "alt-tab"
      "iterm2"
      "audacity"
      "handbrake"
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
      "prismlauncher"
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
      "playcover-community"
    ];
  };
}
