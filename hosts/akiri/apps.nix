{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    curie
  ];
    
  environment.variables = {
      ROSETTA_ADVERTISE_AVX = "1";
  };

  environment.systemPackages = with pkgs; [
    # CLI
    aria2
    btop
    uv
    eza
    gh
    go
    nim
    nimble
    just
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
    aider-chat

    # GUI apps
    discord
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
    mos
    net-news-wire
    upscayl
    #signal-desktop
  ];

  # Launchd
  launchd = {
    user = {
	  agents = {
	    spoofdpi = {
		  command = "${pkgs.spoofdpi}/bin/spoofdpi -enable-doh -window-size 1 -pattern '\\bdiscord\\b' -pattern '\\bdiscordapp\\b' -pattern '\\bnyaa\\b' -pattern '\\bgelbooru\\b' -pattern '\\bdanbooru\\b' -pattern '\\btumblr\\b' -pattern '\\b4chan\\b' -pattern '\\bhianime\\b' -pattern '\\bpastebin\\b' -pattern '\\bwikihow\\b' -pattern '\\bprotonvpn\\b' -pattern '\\be-hentai\\b'";
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
      "iterm2"
      "signal"
	  "notion"
      "cursor"
      "zed"
	  "affinity-designer"
	  "affinity-photo"
	  "affinity-publisher"
      "vivaldi"
      "playcover-community"
      "claude"
    ];
  };
}
