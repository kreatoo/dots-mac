{
  pkgs,
  lib,
  systemName,
  ...
}:
let
  uopts = import ./options.nix;
in
{
  home.stateVersion = "24.11";

  _module.args = { inherit uopts systemName; };

  home.enableNixpkgsReleaseCheck = false;

  programs.nixvim = {
    nixpkgs.source = pkgs.path;
    version.enableNixpkgsReleaseCheck = false;
  };

  imports = [
    ./packages.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./nushell.nix
    ./neovide-config.nix
    ./opencode.nix
    ./pi.nix
    ./opnix.nix
    ./modules/work.nix
    ./modules/home.nix
  ] ++ lib.optionals uopts.programs.nixvim.enable [ ./neovim.nix ];
}
