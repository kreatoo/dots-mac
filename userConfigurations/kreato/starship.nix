{ lib, uopts, ... }: {
  programs.starship = lib.mkIf uopts.programs.starship.enable {
    enable = true;
    enableZshIntegration = uopts.programs.zsh.enable;
  };
}
