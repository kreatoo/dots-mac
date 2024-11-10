{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        aria2
        btop
        eza
        gh
        go
        nim
        neovim
        tree
        nodejs
        starship
        zsh-autosuggestions
        zsh-syntax-highlighting
        dnscrypt-proxy
        fastfetch
    ];

    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = true;
        };

        casks = [
            "1password"
            "aerospace"
            "alt-tab"
            "docker"
            "dozer"
            "font-jetbrains-mono-nerd-font"
            "google-chrome"
            "iterm2"
            "keyboardcleantool"
            "raycast"
            "rectangle"
            "signal"
            "soundsource"
            "stremio"
            "the-unarchiver"
            "tuta-mail"
            "utm"
            "vivaldi"
            "vmware-fusion"
        ];
    };
}
