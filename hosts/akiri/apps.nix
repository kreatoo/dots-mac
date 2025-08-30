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
    bun
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
    fd

    # GUI apps
    google-chrome
    gzdoom
    vscode
    localsend
    prismlauncher
    alt-tab-macos
    audacity
    ice-bar
    iina
    utm
    rectangle
    soundsource
    the-unarchiver
    mos
    upscayl
    youtube-music
    #signal-desktop
  ];

  # Launchd
  launchd = {
    user = {
	  agents = {
	    spoofdpi = {
		  command = "${pkgs.spoofdpi}/bin/spoofdpi -enable-doh -window-size 1 -pattern '\\bdiscord\\b' -pattern '\\bdiscordapp\\b' -pattern '\\bnyaa\\b' -pattern '\\bgelbooru\\b' -pattern '\\bdanbooru\\b' -pattern '\\btumblr\\b' -pattern '\\b4chan\\b' -pattern '\\bhianime\\b' -pattern '\\bpastebin\\b' -pattern '\\bwikihow\\b' -pattern '\\bprotonvpn\\b' -pattern '\\be-hentai\\b' -pattern '\\bmullvad\\b' -pattern '\\bguilded\\b' -pattern '\\bsiker\\b' -pattern '\\bxda-developers\\b'";
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
      "freelens"
      "balenaetcher"
      "galaxybudsclient"
      "msty"
      "easy-move+resize"
      "firefox"
      "orbstack"
	  "sf-symbols"
      "imageoptim"
      "discord"
      "anki"
	  "font-sf-mono"
      "appcleaner"
      "omnidisksweeper"
      "handbrake"
      "tuta-mail"
	  "font-sf-pro"
      "obs"
      "keyboardcleantool"
      "betterdisplay"
      "iterm2"
      "signal"
	  "notion"
      "hyperkey"
      "cursor"
      "kdenlive"
	  "affinity-designer"
	  "affinity-photo"
	  "affinity-publisher"
      "vivaldi"
      "playcover-community"
    ];
  };
}
