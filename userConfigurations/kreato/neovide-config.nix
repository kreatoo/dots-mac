{ lib, uopts, ... }: {
  programs.neovide = lib.mkIf uopts.programs.neovide.enable {
    enable = true;
    settings = {
      wsl = false;
    };
  };
}
