{ config, pkgs, lib, ... }:

{
    home.stateVersion = "24.11";

    # ZSH
    programs.zsh.enable = true;
    programs.zsh.enableCompletion = true;
    programs.zsh.autosuggestion.enable = true;
    programs.zsh.shellAliases = {
        ls = "eza";
        vim = "nvim";
    };

    # Starship
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
    };
}
