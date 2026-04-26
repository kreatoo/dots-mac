{
  nix.enable = false;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  system.primaryUser = "kreato";
}
