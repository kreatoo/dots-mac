{
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  nix.configureBuildUsers = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
}
