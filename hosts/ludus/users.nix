let
  vars = import ./options.nix;
in
{
  # Create the deck user (Steam Deck default user)
  users.users."${vars.userName}" = {
    isNormalUser = true;
    home = "/home/${vars.userName}";
    description = "Steam Deck User";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "deck";
  };

  # Set trusted users for Nix
  nix.settings.trusted-users = [ vars.userName ];
}



