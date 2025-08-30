{ pkgs, ... }:

{
  nix = {
    settings = {
        experimental-features = "nix-command flakes";
    };
    
    gc = {
      automatic = true;
      interval = {
          Weekday = 0;
          Hour = 0;
          Minute = 0;
      };
      options = "--delete-older-than 7d";
    };

    optimise = {
        automatic = true;
    };

    package = pkgs.nix;
  };
}
