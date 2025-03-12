{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  nix.package = pkgs.nix;
}
