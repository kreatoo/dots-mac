{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    #home-manager.url = "github:nix-community/home-manager";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#akiri
    darwinConfigurations."akiri" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/akiri/apps.nix
        ./hosts/akiri/nix.nix
        ./hosts/akiri/system.nix
        ./hosts/akiri/users.nix
        #home-manager.darwinModules.home-manager
        #home-manager.useGlobalPkgs = true;
        #home-manager.useUserPackages = true;
        #home-manager.users.kreato = import ./hosts/akiri/userConfigurations/kreato.nix;
      ];
    };
  };
}
