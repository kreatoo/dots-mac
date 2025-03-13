{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    # CLI
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
	spoofdpi
	qemu
    watch
    k9s
    docker
    inetutils
    procps

    # GUI apps
    discord
    iterm2
    google-chrome
    arc-browser
    gzdoom
    vscode
    localsend
    prismlauncher
    alt-tab-macos
    audacity
    iina
    utm
    rectangle
    lens
    soundsource
    the-unarchiver
    #signal-desktop
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
      "transmission"
      "balenaetcher"
      "galaxybudsclient"
      "msty"
      "orbstack"
	  "sf-symbols"
	  "font-sf-mono"
      "handbrake"
      "tuta-mail"
	  "font-sf-pro"
      "keyboardcleantool"
      "signal"
	  "notion"
	  "affinity-designer"
	  "affinity-photo"
	  "affinity-publisher"
      "vivaldi"
      "playcover-community"
    ];
  };
}
