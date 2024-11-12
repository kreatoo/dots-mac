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
  ];

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
    ];
  };
}
