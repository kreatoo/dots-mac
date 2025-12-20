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

  imports = [
    ./packages.nix
    ./zsh.nix
    ./starship.nix
    ./nushell.nix
    ./neovide-config.nix
    ./opencode.nix
  ] ++ lib.optionals uopts.programs.nixvim.enable [ ./neovim.nix ];
}
